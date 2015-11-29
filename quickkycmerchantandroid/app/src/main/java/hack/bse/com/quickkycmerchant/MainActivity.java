package hack.bse.com.quickkycmerchant;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Toolbar toolbar = (Toolbar) findViewById(R.id.my_awesome_toolbar);
        setSupportActionBar(toolbar);
    }

    public void openQrGenerator(View view) {
        Intent intent = new Intent(this, GenerateQRCodeActivity.class);
        startActivity(intent);
    }

    public void login(View view) {
        Intent intent = new Intent(this, LoginActivity.class);
        startActivity(intent);
    }

    public void formList(View view) {
        Intent intent = new Intent(this, FormListActivity.class);
        startActivity(intent);
    }

    public void showForm(View view) {
        Intent intent = new Intent(this, FormViewActivity.class);
        startActivity(intent);
    }
}
