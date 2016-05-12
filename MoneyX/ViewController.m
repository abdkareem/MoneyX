//
//  ViewController.m
//  MoneyX
//
//  Created by Taiyaba Sultana on 5/10/16.
//  Copyright © 2016 Abdul Kareem. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    id variable;
    NSDictionary *currenciesList;
    NSArray *tempArray;
}
@property (weak, nonatomic) IBOutlet UIPickerView *currencyList;

- (void) setCurrencies;
- (void) makeApiCall: (NSString *)currencyCode;

@end

@implementation ViewController

- (void) setCurrencies {
    currenciesList = @{
                       //if NSArray used we need currency 3 digit equivalent which any user won't be able to understand
                       @"Australian Dollar" : @"AUD",
                       @"Canadian Dollar" : @"CAD",
                       @"Swiss Franc" : @"CHF",
                       @"Chinese Yuan" : @"CNY",
                       @"Euro" : @"EUR",
                       @"British Pound Sterling" : @"GBP",
                       @"Hong Kong Dollar" : @"HKD",
                       @"Indonesian Rupiah" : @"IDR",
                       @"Indian Rupee" : @"INR",
                       @"Japanese Yen" : @"JPY",
                       @"South Korean Won" : @"KRW",
                       @"Malaysian Ringgit" : @"MYR",
                       @"Singapore Dollar" : @"SGD",
                       @"Thai Baht" : @"THB",
                       @"United States Dollar" : @"USD",
                       @"South African Rand" : @"ZAR",
                       @"Israeli New Sheqel" : @"ILS",
                       @"Indonesian Rupiah" : @"IDR",
                       };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"MoneyX";
    [self setCurrencies];
    self.currencyList.delegate = self;
    self.currencyList.dataSource = self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return currenciesList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView  titleForRow:(NSInteger)row  forComponent:(NSInteger)component {
    tempArray = [currenciesList allKeys];
    return tempArray[row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    tempArray = [currenciesList allValues];
    [self makeApiCall: tempArray[row]];
    NSLog(@"\nReturns back from makeApiCall method");
    [self presentViewController:resultsVC animated:YES completion:nil];
}

/*
- (NSInteger)selectedRowInComponent:(NSInteger)component {
    return
}
*/

- (void) makeApiCall: (NSString *)currencyCode {
    //NSMutableString *baseApiLatestJsonAppid = [NSMutableString stringWithString:@"https://openexchangerates.org/api/latest.json?app_id=8199fafc033e4ca3945b9d105466d90a&base="];
    NSMutableString *baseApiLatestJsonAppid = [NSMutableString stringWithString:@"http://api.fixer.io/latest?base="];
    [baseApiLatestJsonAppid appendFormat:@"%@",currencyCode];
    NSLog(@"api to be called is : %@", baseApiLatestJsonAppid);
    NSURL *urlWithUSLandingAPICall = [NSURL URLWithString:baseApiLatestJsonAppid];
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
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
