<!DOCTYPE html>
<html>
<head>
	<?php echo $this->Html->charset(); ?>
	<?php
		echo $this->Html->css('bootstrap.min');
		echo $this->Html->css('style');
		echo $this->Session->flash();
	?>
</head>
<body>
	<section class="pagehead">
		<div class="container">
		    <div class="row">
		        <div class="col-xs-12 text-center">
		        <h3>Merchant</h3> 
				</div>
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
