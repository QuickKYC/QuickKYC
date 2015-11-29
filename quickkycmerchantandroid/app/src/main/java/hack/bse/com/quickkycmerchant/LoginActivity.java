package hack.bse.com.quickkycmerchant;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class LoginActivity extends AppCompatActivity implements Response.Listener, Response.ErrorListener {
    public static final String REQUEST_TAG = "LoginActivity";
    private SharedPreferences sharedpreferences;
    private  static final String MyPREFERENCES = "KYCPrefs" ;
    private RequestQueue mQueue;
    private String url;
    private CustomJSONObjectRequest jsonRequest;
    private JSONObject jsonObject = new JSONObject();
    private ProgressBar loginProgressBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        loginProgressBar = (ProgressBar) findViewById(R.id.loginProgressBar);
        sharedpreferences = getSharedPreferences(MyPREFERENCES, Context.MODE_PRIVATE);
        mQueue = CustomVolleyRequestQueue.getInstance(this.getApplicationContext()).getRequestQueue();

        try {
            ReadJsonFromAssets readJsonFromAssets = new ReadJsonFromAssets();
            JSONArray jsonArray = new JSONArray(readJsonFromAssets.readJson(this, "qkyes"));
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonObject = jsonArray.getJSONObject(i);
                Constants.map.put(jsonObject.getString("id"), jsonObject);
            }
        }
        catch (JSONException e){
            System.out.println(e);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the main; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            showDialog();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    public void openSettings(View view) {
        showDialog();
    }

    private void saveSettings(String key, String url) {
        SharedPreferences.Editor editor = sharedpreferences.edit();
        editor.putString(key, url);
        editor.commit();
    }

    private String getSettings() {
        return sharedpreferences.getString("URL", null);
    }

    public void signIn(View view) {
        try {
            url = sharedpreferences.getString("URL", null);
            if(url != null) {
                url += Url.M_AUTH;

                EditText uName = (EditText) findViewById(R.id.username);
                EditText pswd = (EditText) findViewById(R.id.password);

                jsonObject.put("userid", uName.getText().toString());
                jsonObject.put("password", pswd.getText().toString());
                jsonObject.put("deviceid", "android_123465789");
                jsonObject.put("devicetype", "android");
                /*jsonRequest = new CustomJSONObjectRequest(Request.Method
                        .POST, url,
                        jsonObject, this, this);
                jsonRequest.setTag(REQUEST_TAG);*/

                if(new ConnectionDetector(this).isConnectingToInternet()){
                    PostDataAsync postDataAsync = new PostDataAsync();
                    postDataAsync.execute();
                }
                else{
                    Toast.makeText(this, "Not connected to internet", Toast.LENGTH_SHORT).show();
                }
            }
            else{
                Toast.makeText(this, "Please add server url.", Toast.LENGTH_SHORT).show();
            }
        }
        catch (JSONException e) {
            e.printStackTrace();
        }

        /*if(mQueue != null)
            mQueue.add(jsonRequest);*/
    }

    public void showDialog() {
        final Dialog dialog = new Dialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.setting_popup_layout);

        final EditText settingUrl = (EditText) dialog.findViewById(R.id.settingUrl);
        String url = getSettings();

        if(url != null)
            settingUrl.setText(url);

        Button dialogButton = (Button) dialog.findViewById(R.id.saveSettings);
        dialogButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                saveSettings("URL", settingUrl.getText().toString());
                dialog.dismiss();
            }
        });

        dialog.show();
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (mQueue != null) {
            mQueue.cancelAll(REQUEST_TAG);
        }
    }

    @Override
    public void onErrorResponse(VolleyError error) {
        System.out.println(error.getMessage());
    }

    @Override
    public void onResponse(Object response) {
        try {
            System.out.println(((JSONObject) response));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private class PostDataAsync extends AsyncTask<Void, Void, String> {

        @Override
        protected void onPreExecute() {
            loginProgressBar.setVisibility(ProgressBar.VISIBLE);
            super.onPreExecute();
        }

        @Override
        protected String doInBackground(Void... params) {
            PostData postData = new PostData();
            return postData.postData(url, jsonObject.toString());
        }

        @Override
        protected void onPostExecute(String aVoid) {
            loginProgressBar.setVisibility(ProgressBar.GONE);
            try {
                JSONObject jsonObject = new JSONObject(aVoid);
                if(jsonObject.getString("status").equals("success")){
                    saveSettings("EMP_ID", jsonObject.getString("id"));
                    Toast.makeText(LoginActivity.this, "Logged in successfully", Toast.LENGTH_SHORT).show();

                    Intent intent = new Intent(LoginActivity.this, FormListActivity.class);
                    startActivity(intent);
                }
                else if(jsonObject.getString("status").equals("failure")){
                    Toast.makeText(LoginActivity.this, "Unknown server error", Toast.LENGTH_SHORT).show();
                }
            }
            catch (Exception e){
                System.out.println(e);
                e.printStackTrace();
                Toast.makeText(LoginActivity.this, "Unknown server error", Toast.LENGTH_SHORT).show();
            }
            super.onPostExecute(aVoid);
        }
    }
}