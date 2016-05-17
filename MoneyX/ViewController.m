//
//  ViewController.m
//  MoneyX
//
//  Created by Taiyaba Sultana on 5/10/16.
//  Copyright © 2016 Abdul Kareem. All rights reserved.
//

#import "ViewController.h"
#import "ResultsViewController.h"
@interface ViewController () {
    id variable;
    NSArray *curList;
    NSMutableString *apiString;
}
@property (weak, nonatomic) IBOutlet UIPickerView *currencyList;


- (void) setCurrencies;
- (void) makeApiCall: (NSMutableString*)currencyCode;

@end

@implementation ViewController

- (void) setCurrencies {
    curList = @[
                       //if NSArray used we need currency 3 digit equivalent which any user won't be able to understand
                       @"Australian Dollar  AUD",
                       @"Canadian Dollar  CAD",
                       @"Swiss Franc  CHF",
                       @"Chinese Yuan  CNY",
                       @"Euro  EUR",
                       @"British Pound Sterling  GBP",
                       @"Hong Kong Dollar  HKD",
                       @"Indonesian Rupiah  IDR",
                       @"Indian Rupee  INR",
                       @"Japanese Yen  JPY",
                       @"South Korean Won  KRW",
                       @"Malaysian Ringgit  MYR",
                       @"Singapore Dollar  SGD",
                       @"Thai Baht  THB",
                       @"United States Dollar  USD",
                       @"South African Rand  ZAR",
                       @"Israeli New Sheqel  ILS",
                       @"Indonesian Rupiah  IDR",
                       ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"MoneyX";
    apiString = [NSMutableString stringWithString:@"http://api.fixer.io/latest?base="];
    [self setCurrencies];
    self.currencyList.delegate = self;
    self.currencyList.dataSource = self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return curList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView  titleForRow:(NSInteger)row  forComponent:(NSInteger)component {
    return curList[row];
}

/*
 //This method no longer used
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //tempArray = [currenciesList allValues];
    
    //NSLog(@"\nSelected row is %@", currenciesList[row]);
    //[self presentViewController:resultsVC animated:YES completion:nil];
    [NSThread sleepForTimeInterval:3];
    NSLog(@"Came back");
}
*/

/*- (IBAction)putValuesOnTable:(id)sender {
    ResultsViewController *pResultsViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"resultsVC"];
    [self presentViewController:pResultsViewController animated:YES completion:nil];
}
*/

- (void) makeApiCall: (NSString*)currencyCode {
    //NSLog(@"Received curr code is %@", currencyCode);
    
    //No longer using open exchange rates API instead using Fixer.io API
    //NSMutableString *baseApiLatestJsonAppid = [NSMutableString stringWithString:@"https://openexchangerates.org/api/latest.json?app_id=8199fafc033e4ca3945b9d105466d90a&base="];
    
    NSMutableString *chopCurrCode = [NSMutableString stringWithCapacity:2];
    [chopCurrCode appendString:currencyCode];
    //Help on NSRage http://nshipster.com/nsrange/
    NSUInteger temp = (chopCurrCode.length) - 3;
    [chopCurrCode deleteCharactersInRange:NSMakeRange(0, temp)];
    
    [apiString appendString:chopCurrCode];
    //[apiString appendFormat:@"%@",[currencyCode substringFromIndex:((currencyCode.length) - 1)]];
    NSLog(@"api to be called is : %@", apiString);
    NSURL *urlWithUSLandingAPICall = [NSURL URLWithString:apiString];
    NSURLSession *mainSession = [NSURLSession sharedSession];
    [[mainSession dataTaskWithURL:urlWithUSLandingAPICall completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error encountered %@", error);
            return;
        }
        NSHTTPURLResponse *pointerToStatusCode = (NSHTTPURLResponse *) response;
        if (pointerToStatusCode.statusCode < 200 || pointerToStatusCode.statusCode >= 300) {
            NSLog(@"HTTP error %ld", pointerToStatusCode.statusCode);
            return;
        }
        //Check if there is parse error
        NSError *parseError;
        variable = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (parseError) {
            NSLog(@"Error in parse");
        }
        NSLog(@"Parse return is %@", variable);
    }
      ]resume];
    //[NSThread sleepForTimeInterval:2];
    //NSUInteger temp2 = (apiString.length) - 3;
    //[apiString deleteCharactersInRange:NSMakeRange(temp2,(apiString.length) - 1)];
    
    return;

}

- (IBAction)selectCurrency:(id)sender {
    NSInteger selection = [self.currencyList selectedRowInComponent:0];
    NSLog(@"\n\nCurrency selected is %@", curList[selection]);
    [self makeApiCall: curList[selection]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
