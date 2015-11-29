package hack.bse.com.quickkycmerchant;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.widget.ProgressBar;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class FormListActivity extends AppCompatActivity {

    private ProgressBar formListProgressBar;
    private  static final String MyPREFERENCES = "KYCPrefs" ;
    private String url;
    private List<FormData> list = new ArrayList<>();
    private FormListAdapter formListAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_form_list);

        formListProgressBar = (ProgressBar) findViewById(R.id.formListProgressBar);

        RecyclerView recList = (RecyclerView) findViewById(R.id.cardList);
        recList.setHasFixedSize(true);

        formListAdapter = new FormListAdapter(this, list, recList);
        recList.setAdapter(formListAdapter);

        LinearLayoutManager llm = new LinearLayoutManager(this);
        llm.setOrientation(LinearLayoutManager.VERTICAL);
        recList.setLayoutManager(llm);

        if(new ConnectionDetector(this).isConnectingToInternet()){
            SharedPreferences sharedpreferences = getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE);
            url = sharedpreferences.getString("URL", null);
            if(url != null)
                url += Url.M_ALL_FORM;

            PostDataAsync postDataAsync = new PostDataAsync();
            postDataAsync.execute();
        }
        else{
            Toast.makeText(this, "Not connected to internet", Toast.LENGTH_SHORT).show();
        }
    }

    private class PostDataAsync extends AsyncTask<Void, Void, String> {

        @Override
        protected void onPreExecute() {
            formListProgressBar.setVisibility(ProgressBar.VISIBLE);
            super.onPreExecute();
        }

        @Override
        protected String doInBackground(Void... params) {
            PostData postData = new PostData();
            SharedPreferences sharedpreferences = getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE);
            JSONObject jsonObject = new JSONObject();
            try {
                jsonObject.put("id",  sharedpreferences.getString("EMP_ID", null));
            } catch (JSONException e) {
                e.printStackTrace();
            }
            return postData.postData(url, jsonObject.toString());
        }

        @Override
        protected void onPostExecute(String aVoid) {
            formListProgressBar.setVisibility(ProgressBar.GONE);

            if(aVoid != null) {
                try {
                    JSONArray jsonObject = new JSONArray(aVoid);

                for (int i = 0; i < jsonObject.length(); i++) {
                    list.add(new FormData(jsonObject.getString(i)));
                }
                formListAdapter.notifyDataSetChanged();
                } catch (JSONException e) {
                    System.out.println(e);
                    e.printStackTrace();
                }
            }
            super.onPostExecute(aVoid);
        }
    }
}