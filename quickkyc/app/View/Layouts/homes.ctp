<!DOCTYPE html>
<html>
<head>
	<?php echo $this->Html->charset(); ?>
	<?php
		echo $this->Html->css('bootstrap.min');
		echo $this->Html->css('style');
		echo $this->Session->flash();
		echo $this->Html->script('jquery1.11.3.min.js');
		echo $this->Html->script('bootstrap.js');
	?>
</head>
<body>
	<section class="pagehead">
		<div class="container">
		    <div class="row">
		    <?php if($this->Session->read('isLoggedIn') == '1')
		    {
		    ?>
		    	<div class="row">
		    		<div class="col-xs-1">
		    		</div>
		        	<div class="col-xs-7"><img src="<?php echo $this->webroot?>img/app_icon/company-logo.png" alt="">
					</div>
					<div class="col-xs-2">
						<form action="<?php echo $this->webroot.'login/logout'?>">
        					<button type="submit" class="btn btn-default btn-sm" style="margin-top: 15px">
          						<span class="glyphicon glyphicon-log-out"></span> Log out
       				 		</button>
       					 </form>
					</div>
		   		</div>
		    	<?php
		    }
		    else 
		    {
		    ?>
		        <div class="col-xs-12 text-center"><img src="<?php echo $this->webroot?>img/app_icon/company-logo.png" alt="">
				</div>
			<?php 
		    }
			?>
		    </div>
		</div>
	</section>
	<div id="flashMessage" class="message">
	</div>
	<div id="container">
		<div id="content">
			<?php echo $this->fetch('content'); ?>
		</div>
	</div>
	<?php echo $this->element('sql_dump'); ?>
</body>
</html>
 