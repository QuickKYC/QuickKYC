/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "ViewController.h"
#import "CategoryViewController.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"


#define QR_SEGUE @"ScanQRSegue"

@interface ViewController ()
{
	id jsonDictionary;
}

@end

@implementation ViewController

- (void) viewDidLoad
{
	[super viewDidLoad];
	self.navigationController.navigationBar.hidden = YES;
	self.navigationItem.hidesBackButton = YES;
}

- (IBAction)scanAction:(id)sender
{
	if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
		static QRCodeReaderViewController *vc = nil;
		static dispatch_once_t onceToken;
		
		dispatch_once(&onceToken, ^{
			QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
			vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
			vc.modalPresentationStyle = UIModalPresentationFormSheet;
		});
		vc.delegate = self;
		
		[vc setCompletionWithBlock:^(NSString *resultAsString) {
			NSLog(@"Completion with result: %@", resultAsString);
		}];
		
		[self presentViewController:vc animated:YES completion:NULL];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alert show];
	}
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
	[self dismissViewControllerAnimated:YES completion:^{
		/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];*/
		NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
		jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
		[self performSegueWithIdentifier:QR_SEGUE sender:nil];
	}];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:QR_SEGUE])
	{
		CategoryViewController *cvc = segue.destinationViewController;
		[cvc loadFromDictionary:jsonDictionary];
	}
}

@end
