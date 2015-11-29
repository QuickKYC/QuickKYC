package hack.bse.com.quickkycmerchant;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Typeface;
import android.util.Base64;
import android.util.LruCache;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.BaseExpandableListAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.RequestQueue;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Created by dheeraj on 28/11/15.
 */
public class ExpandableListAdapter extends BaseExpandableListAdapter {

    private Context _context;
    private List<String> _listDataHeader; // header titles
    // child data in format of header title, child title
    private LinkedHashMap<String, List<JSONObject>> _listDataChild;
    private Map<String, String> tmpValMap;
    private RequestQueue mRequestQueue;
    private ImageLoader mImageLoader;
    private String tmpbase64 = "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";

    public ExpandableListAdapter(Context context, List<String> listDataHeader,
                                 LinkedHashMap<String, List<JSONObject>> listChildData, Map<String, String> tmpValMap) {
        this._context = context;
        this._listDataHeader = listDataHeader;
        this._listDataChild = listChildData;
        this.tmpValMap = tmpValMap;

        mRequestQueue = Volley.newRequestQueue(context);
        mImageLoader = new ImageLoader(mRequestQueue, new ImageLoader.ImageCache() {
            private final LruCache<String, Bitmap> mCache = new LruCache<String, Bitmap>(10);
            public void putBitmap(String url, Bitmap bitmap) {
                mCache.put(url, bitmap);
            }
            public Bitmap getBitmap(String url) {
                return mCache.get(url);
            }
        });
    }

    @Override
    public Object getChild(int groupPosition, int childPosititon) {
        return this._listDataChild.get(this._listDataHeader.get(groupPosition)).get(childPosititon);
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }

    @Override
    public View getChildView(int groupPosition, final int childPosition,
                             boolean isLastChild, View convertView, ViewGroup parent) {

        final JSONObject childText = (JSONObject) getChild(groupPosition, childPosition);
        if (convertView == null) {
            LayoutInflater infalInflater = (LayoutInflater) this._context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = infalInflater.inflate(R.layout.list_item, null);
        }

        TextView txtListChildKey = (TextView) convertView.findViewById(R.id.lblListItemKey);
        TextView txtListChildValue = (TextView) convertView.findViewById(R.id.lblListItemValue);
        try {
            txtListChildKey.setText(childText.getString("name"));
            txtListChildValue.setText(tmpValMap.get(childText.getString("id")));

            if(childText.getString("type").equals("Date")) {
                try {
                    SimpleDateFormat format = new SimpleDateFormat("ddMMyyyy");
                    SimpleDateFormat formatOut = new SimpleDateFormat("dd MMMM yyyy", Locale.ENGLISH);
                    if(tmpValMap.get(childText.getString("id")) != null){
                        Date strToDate = format.parse(tmpValMap.get(childText.getString("id")));
                        txtListChildValue.setText(formatOut.format(strToDate));
                    }
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
            else if(childText.getString("type").equals("DOC")){
//                System.out.println(tmpValMap.get(childText.getString("id")));
//                System.out.println(childText.getString("name"));
//                System.out.println(childText.getString("data"));
//                System.out.println(childText.getString("mname"));
//                System.out.println(childText.getString("comment"));
//                System.out.println(childText.getString("verified"));

                if(new JSONObject(tmpValMap.get(childText.getString("id"))).getString("verified").equals("1")){
//                    txtListChildValue.setTextColor(_context.getResources().getColor());
                }

                txtListChildValue.setText(new JSONObject(tmpValMap.get(childText.getString("id"))).getString("name"));
                txtListChildValue.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
//                        try {
//                            showImage(decodeBase64(childText.getString("data")));
                        showImage(decodeBase64(tmpbase64));
//                        } catch (JSONException e) {
//                            e.printStackTrace();
//                        }
                    }
                });
            }
        }
        catch (JSONException e){
            System.out.println(e);
        }
        return convertView;
    }

    public static Bitmap decodeBase64(String input) {
        byte[] decodedByte = Base64.decode(input, 0);
        return BitmapFactory.decodeByteArray(decodedByte, 0, decodedByte.length);
    }

    private void showImage(Bitmap bitmap){
        final Dialog dialog = new Dialog(_context);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.verify_doc_layout);

        Button dialogAprButton = (Button) dialog.findViewById(R.id.approve);
        Button dialogRejButton = (Button) dialog.findViewById(R.id.reject);

        ImageView avatar = (ImageView) dialog.findViewById(R.id.imageView);
        avatar.setImageBitmap(bitmap);
        //avatar.setImageUrl("http://someurl.com/image.png", mImageLoader);

        dialogAprButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        dialogRejButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });

        dialog.show();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return this._listDataChild.get(this._listDataHeader.get(groupPosition))
                .size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return this._listDataHeader.get(groupPosition);
    }

    @Override
    public int getGroupCount() {
        return this._listDataHeader.size();
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded,
                             View convertView, ViewGroup parent) {
        String headerTitle = (String) getGroup(groupPosition);
        if (convertView == null) {
            LayoutInflater infalInflater = (LayoutInflater) this._context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = infalInflater.inflate(R.layout.list_group, null);
        }

        TextView lblListHeader = (TextView) convertView
                .findViewById(R.id.lblListHeader);
        lblListHeader.setTypeface(null, Typeface.BOLD);
        lblListHeader.setText(headerTitle);

        ExpandableListView mExpandableListView = (ExpandableListView) parent;
        mExpandableListView.expandGroup(groupPosition);

        return convertView;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return true;
    }
}