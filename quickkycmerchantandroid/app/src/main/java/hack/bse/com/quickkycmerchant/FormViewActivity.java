package hack.bse.com.quickkycmerchant;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ExpandableListView;
import android.widget.ProgressBar;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class FormViewActivity extends AppCompatActivity {

    private ExpandableListAdapter listAdapter;
    private ExpandableListView expListView;
    private List<String> listDataHeader;
    private LinkedHashMap<String, List<JSONObject>> listDataChild;
    private JSONArray jsonQKKeysArray;
    private JSONArray jsonQKDocArray;
    private Map<String, String> tmpValMap;
    private ProgressBar formViewProgressBar;
    private String url;
    private String urlVerify;
    private String rfId;
    private  static final String MyPREFERENCES = "KYCPrefs" ;

    /*private String tmpStr = "{\n" +
            "\t\"refid\": \"12\",\n" +
            "\t\"fname\": \"Saving Account\",\n" +
            "\t\"mname\": \"Barclays\",\n" +
            "\t\"qk_keys\": [\n" +
            "\t\t{\"qkid\": \"QK_PRF_NAME\", \"value\": \"Ashish\"},\n" +
            "\t\t{\"qkid\": \"QK_PRF_GENDER\", \"value\": \"Male\"},\n" +
            "\t\t{\"qkid\": \"QK_PRF_DOB\", \"value\": \"03071989\"},\n" +
            "\t\t{\"qkid\": \"QK_PRF_MARITALSTATUS\", \"value\": \"Single\"},\n" +
            "\t\t{\"qkid\": \"QK_ID_PAN\", \"value\": \"B528889277\"},\n" +
            "\t\t{\"qkid\": \"QK_ID_DL\", \"value\": \"Rj/gf/asgd/1922\"},\n" +
            "\t\t{\"qkid\": \"QK_CNT_EMAIL1\", \"value\": \"ashish0389@gmail.com\"},\n" +
            "\t\t{\"qkid\": \"QK_CNT_PHONE_MOBILE_1\", \"value\": \"9353012253\"},\n" +
            "\t\t{\"qkid\": \"QK_CNT_PHONE_RES_2\", \"value\": \"01412672429\"},\n" +
            "\t\t{\"qkid\": \"QK_CNT_HOMEADDR\", \"value\": \"Jalmahal, Jaipur\"},\n" +
            "\t\t{\"qkid\": \"QK_FIN_ANNUALSALARY\", \"value\": \"\"},\n" +
            "\t\t{\"qkid\": \"QK_MED_BLOODGROUP\", \"value\": \"O+\"}\n" +
            "\t],\n" +
            "\t\"qk_docs\": [\n" +
            "\t\t{\"qkid\": \"QK_DOC_PAN\", \"name\": \"pancopy.png\", \"data\": \"base64image\", \"mname\": \"Barclays\", \"comment\": \"Verified by Ram\", \"verified\": 1},\n" +
            "\t\t{\"qkid\": \"QK_DOC_DL\", \"name\": \"dlcopy.png\", \"data\": \"base64image\", \"mname\": \"Barclays\", \"comment\": \"Verified by Ram\", \"verified\": 1}\n" +
            "\t]\n" +
            "}";*/

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_form_view);

        formViewProgressBar = (ProgressBar) findViewById(R.id.formViewProgressBar);

        SharedPreferences sharedpreferences = getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE);
        url = sharedpreferences.getString("URL", null);
        if(url != null){
            url += Url.M_GET_FORM;
            urlVerify += Url.M_VALIDATE;
        }

        expListView = (ExpandableListView) findViewById(R.id.lvExp);
        expListView.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
            public boolean onGroupClick(ExpandableListView arg0, View itemView, int itemPosition, long itemId) {
                expListView.expandGroup(itemPosition);
                return true;
            }
        });

        if(new ConnectionDetector(this).isConnectingToInternet()){
            String fid = getIntent().getStringExtra("fid");
            if(fid != null) {
                PostDataAsync postDataAsync = new PostDataAsync(fid);
                postDataAsync.execute();
            }
        }
        else{
            Toast.makeText(this, "Not connected to internet", Toast.LENGTH_SHORT).show();
        }
    }

    public void verify(View view) {
        if(new ConnectionDetector(this).isConnectingToInternet()){

            SharedPreferences sharedpreferences = getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE);
            JSONObject jsonObject = new JSONObject();
            try {

                jsonObject.put("refid", rfId);
                jsonObject.put("empid", sharedpreferences.getString("EMP_ID", null));

                if(jsonQKDocArray != null){
                    JSONArray jsonArray = new JSONArray();
                    for (int i = 0; i < jsonQKDocArray.length(); i++) {
                        JSONObject tmp = new JSONObject();
                        tmp.put("md5", jsonQKDocArray.getJSONObject(i).getString("name"));
                        jsonArray.put(tmp);
                    }

                    jsonObject.put("qk_docs", jsonArray);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
            System.out.println(jsonObject);
            VerifyPostDataAsync postDataAsync = new VerifyPostDataAsync(jsonObject);
            postDataAsync.execute();
        }
        else{
            Toast.makeText(this, "Not connected to internet", Toast.LENGTH_SHORT).show();
        }
    }

    private void prepareListData(Map<String, JSONObject> map, JSONObject jsonObject) {
        LinkedHashMap<String, List<JSONObject>> tmpMap = new LinkedHashMap<>();
        listDataHeader = new ArrayList<>();
        try {
            rfId = jsonObject.getString("refid");
            if(jsonObject.has("qk_docs")){
                jsonQKDocArray = jsonObject.getJSONArray("qk_docs");
            }
            jsonQKKeysArray = jsonObject.getJSONArray("qk_keys");

            tmpValMap = new HashMap<>();
            for (int i = 0; i < jsonQKKeysArray.length(); i++) {
                tmpValMap.put(jsonQKKeysArray.getJSONObject(i).getString("qkid"), jsonQKKeysArray.getJSONObject(i).getString("value"));
            }

            if(jsonQKDocArray != null){
                for (int i = 0; i < jsonQKDocArray.length(); i++) {
                    tmpValMap.put(jsonQKDocArray.getJSONObject(i).getString("qkid"), jsonQKDocArray.getJSONObject(i).toString());
                }
            }

            for (Map.Entry<String, JSONObject> entry : map.entrySet()) {
                JSONObject tmp = entry.getValue();
                if(!tmpMap.containsKey(tmp.getString("category")) && tmpValMap.containsKey(entry.getKey())){
                    List<JSONObject> list = new LinkedList<>();
                    list.add(entry.getValue());
                    listDataHeader.add(tmp.getString("category"));
                    tmpMap.put(tmp.getString("category"), list);
                }
                else{
                    if(tmpValMap.containsKey(entry.getKey()))
                        tmpMap.get(tmp.getString("category")).add(entry.getValue());
                }
            }
            listDataChild = tmpMap;
        }
        catch (JSONException e){
            System.out.println(e);
            e.printStackTrace();
        }
    }

    private class PostDataAsync extends AsyncTask<Void, Void, String> {
        private String fid;
        public PostDataAsync(String fid){
            this.fid = fid;
        }

        @Override
        protected void onPreExecute() {
            formViewProgressBar.setVisibility(ProgressBar.VISIBLE);
            super.onPreExecute();
        }

        @Override
        protected String doInBackground(Void... params) {
            JSONObject jsonObject = new JSONObject();
            try {
                jsonObject.put("id", fid);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            return new PostData().postData(url, jsonObject.toString());
        }

        @Override
        protected void onPostExecute(String aVoid) {
            formViewProgressBar.setVisibility(ProgressBar.GONE);
            try {
                System.out.println(aVoid);
//                JSONObject jsonObject = new JSONObject(tmpStr);
                JSONObject jsonObject = new JSONObject(aVoid);
                prepareListData(Constants.map, jsonObject);

                listAdapter = new ExpandableListAdapter(FormViewActivity.this, listDataHeader, listDataChild, tmpValMap);
                expListView.setAdapter(listAdapter);
            }
            catch (JSONException e){
                System.out.println(e);
                e.printStackTrace();
            }
            super.onPostExecute(aVoid);
        }
    }

    private class VerifyPostDataAsync extends AsyncTask<Void, Void, String> {
        private JSONObject jsonObject;

        public VerifyPostDataAsync(JSONObject jsonObject){
            this.jsonObject = jsonObject;
        }

        @Override
        protected void onPreExecute() {
            formViewProgressBar.setVisibility(ProgressBar.VISIBLE);
            super.onPreExecute();
        }

        @Override
        protected String doInBackground(Void... params) {
            System.out.println(urlVerify);
            System.out.println(jsonObject);
            return new PostData().postData(urlVerify, jsonObject.toString());
        }

        @Override
        protected void onPostExecute(String aVoid) {
            formViewProgressBar.setVisibility(ProgressBar.GONE);
            try {
                System.out.println(aVoid);
                JSONObject jsonObject = new JSONObject(aVoid);
                if(jsonObject.getString("status").equals("success")){
                    if(jsonObject.has("sharedata")){
                        JSONArray jsonArray = jsonObject.getJSONArray("sharedata");
                        if(jsonArray!= null && jsonArray.length() > 0){
                            Intent intent = new Intent(FormViewActivity.this, GenerateQRCodeActivity.class);
                            intent.putExtra("tmpStr", jsonArray.toString());
                            startActivity(intent);
                        }
                        else{
                            finish();
                        }
                    }
                }
            }
            catch (JSONException e){
                System.out.println(e);
                e.printStackTrace();
            }
            super.onPostExecute(aVoid);
        }
    }
}
