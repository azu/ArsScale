# ArsScale [![Build Status](https://travis-ci.org/azu/ArsScale.png)](https://travis-ci.org/azu/ArsScale)

A port into Objective-C of the [D3.js Scales](https://github.com/mbostock/d3/wiki/Scales "Scales").

## Installation

```
pod 'ArsScale', :git => 'https://github.com/azu/ArsScale.git'
```

## Usage

```objc
NSArray *dataArray = @[@1, @5, @10, @18, @22, @44, @55, @114];
ArsScaleLinear *scaleLinear = [[ArsScaleLinear alloc] init];
CGSize canvasSize = CGSizeMake(320, 480);
scaleLinear.domain = @[ArsMin(dataArray), ArsMax(dataArray)];
scaleLinear.range = @[@0, @(canvasSize.width)];
scaleLinear.clamp = YES;
scaleLinear.niceByStep([dataArray count]);
for (NSNumber *value in dataArray) {
    NSLog(@"Value:%@ , Scaled: %@", value, [scaleLinear scale:value]);
}
/*
Value:1 , Scaled: 2.666666666666667
Value:5 , Scaled: 13.33333333333333
Value:10 , Scaled: 26.66666666666666
Value:18 , Scaled: 48
Value:22 , Scaled: 58.66666666666666
Value:44 , Scaled: 117.3333333333333
Value:55 , Scaled: 146.6666666666667
Value:114 , Scaled: 304
*/
[linear ticks:10];
/* e.g) use for axis label
(
    0,
    10,
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    90,
    100,
    110,
    120
)
*/
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

MIT