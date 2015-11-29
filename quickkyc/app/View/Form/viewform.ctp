<div class="wrapper">
	<div class="content-main">
		<br/>
		<div class="form-group">
			<div class="row">
				<div class="col-sm-2">
				</div>
				<div class="col-sm-4">
					<div class="pull-left">
					<br/>
						<span class="pull-left" style="font-size: 20px"><?php echo $formdata['Merchant']['name']?></span><br/>
						<br/><span class="pull-left"><?php echo $formdata['Form']['name']?></span><br/><br/>
						<span class="pull-left"><?php echo "Form id : ".$formdata['Form']['id']?></span><br/>
					</div>
				</div>
				<div class="col-sm-1">
				</div>
				<div class="col-sm-2">
					<div class="pull-right" data-toggle="modal" data-target="#myModal"><? echo $this->QrCode->text($jsondata, '150x150'); ?></div>
				</div>
				<div class="col-sm-4">
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-2">
			</div>
			<div class="col-sm-7">
				<hr>
			</div>
			<div class="col-sm-2">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-2">
			</div>
			<div class="col-sm-7">
				<span style="height: 2px; background: #000"></span>
			</div>
			<div class="col-sm-4">
			</div>
			
		</div>
		<br/>
		<form class="form-horizontal" action="<?php echo $this->webroot.'login/login'?>" id="login_form" method="post">
		  	<?php 
		  	$i = 0;
		  	$this->log($qkkeys);
		  	foreach($formdata['FormKey'] as $fData)
		  	{
		  		$qId = $fData['qk_id'];
		  		$name = $qkkeys[$fData['qk_id']]['name'];
		  		$type = $qkkeys[$fData['qk_id']]['type'];
		  		$minlength = $fData['minlength'];
		  		$html = "";
		  		if($type == 'Enum')
		  		{
		  			$options = '';
		  			foreach ($qkkeys[$fData['qk_id']]['options'] as $opt)
		  			{
		  				$options = $options.'<option>'.$opt['value'].'</option>';
		  			}
			
			  		$html = $html.'<div class="form-group">';
			  		$html = $html.'<div class="col-sm-2">';
			  		$html = $html.'</div>';
			  		$html = $html.'<label for="input_'.$i.'" class="col-sm-2 ">'.$name.'</label>';
			  		$html = $html.'<div class="col-sm-5">';
			  		$html = $html.'<select class="form-control" id="input_'.$i.'">';
			  		$html = $html.$options;
			  		$html = $html.'</select>';
			  		$html = $html.'</div>';
			  		$html = $html.'</div>';
		  		}
		  		else 
		  		{
		  			
		  			$html = $html.'<div class="form-group">';
		  			$html = $html.'<div class="col-sm-2">';
		  			$html = $html.'</div>';
		  			$html = $html.'<label for="input_'.$i.'" class="col-sm-2 ">'.$name.'</label>';
		  			$html = $html.'<div class="col-sm-5">';
		  			$html = $html.'<input type="'.$type.'" class="form-control" id="input_'.$i.'"  name="data[Form]['.$qId.']" minlength="'.$minlength.'">';
		  			$html = $html.'</div>';
		  			$html = $html.'</div>';
		  		}
		  		echo $html;
		  		$i++;
		  	}
		  	?>
		</form>
  	</div>
</div>
 <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-body" style="margin-left: 20%">
        
         <? echo $this->QrCode->text($jsondata, '500x500'); ?>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
</div>
