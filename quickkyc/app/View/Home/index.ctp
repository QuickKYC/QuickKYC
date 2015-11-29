<div class="wrapper">
	<div class="content-main">
		<br/><br/><br/><br/><br/><br/><br/><br/><br/>
		<form class="form-horizontal" action="<?php echo $this->webroot.'login/login'?>" id="login_form" method="post">
		  	<div class="form-group">
		  		<div class="col-sm-4"></div>
		    	<div class="col-sm-4">
		     	 	<input type="email" class="form-control" id="inputEmail" placeholder="Email" name="data[Login][email]">
		    	</div>
		  	</div>
			<div class="form-group">
				<div class="col-sm-4"></div>
			    <div class="col-sm-4">
			      <input type="password" class="form-control" id="inputPassword" placeholder="Password" name="data[Login][password]">
			    </div>
			</div>
		   <div class="form-group">
		   	 <div class="col-sm-4"></div>
		      <div class=" col-sm-4 text-right">
		          <button type="submit" class="btn btn-primary btn-block">Sign in</button>
		      </div>
		   </div>
		</form>
  	</div>
</div>
