package hack.bse.com.quickkycmerchant;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import java.util.List;

/**
 * Created by dheeraj on 28/11/15.
 */
public class FormListAdapter extends RecyclerView.Adapter<FormListAdapter.FormViewHolder> {
    private List<FormData> formList;
    private Context context;
    private RecyclerView recyclerView;

    public FormListAdapter(Context context, List<FormData> contactList, RecyclerView recyclerView) {
        this.formList = contactList;
        this.context = context;
        this.recyclerView = recyclerView;
    }

    @Override
    public int getItemCount() {
        return formList.size();
    }

    @Override
    public void onBindViewHolder(FormViewHolder contactViewHolder, int i) {
        FormData ci = formList.get(i);
        contactViewHolder.vName.setText("Form #" + ci.name);
    }

    @Override
    public FormViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View itemView = LayoutInflater.from(viewGroup.getContext()).
                inflate(R.layout.form_list_card, viewGroup, false);

        return new FormViewHolder(itemView, formList, context);
    }

    public static class FormViewHolder extends RecyclerView.ViewHolder {
        protected TextView vName;

        public FormViewHolder(View v, final List<FormData> formList, final Context context ) {
            super(v);
            vName =  (TextView) v.findViewById(R.id.txtName);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(context, FormViewActivity.class);
                    intent.putExtra("fid", formList.get(getAdapterPosition()).name);
                    context.startActivity(intent);
                }
            });
        }
    }
}