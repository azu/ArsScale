# ArsScale [![Build Status](https://travis-ci.org/azu/ArsScale.png)](https://travis-ci.org/azu/ArsScale)

Objective-C port of [D3.js Scales](https://github.com/mbostock/d3/wiki/Scales "Scales").

* Support Linear scale.

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

## API

```objc
@interface ArsScaleLinear : ArsScale
// extend the scale domain to nice round numbers.
// @see https://github.com/mbostock/d3/wiki/Quantitative-Scales#wiki-linear_nice
// @example `linear.nice()`
- (void (^)(void))nice;

// @example `linear.niceByStep(10)`
- (void (^)(NSUInteger))niceByStep;

// enable or disable clamping of the output range.
// @see https://github.com/mbostock/d3/wiki/Quantitative-Scales#wiki-linear_clamp
@property(nonatomic, getter=isClamp) BOOL clamp;
#pragma mark - block
@property(nonatomic, copy) ArsInterpolate interpolate;
@property(nonatomic, copy) ArsUninterpolate uninterpolate;
#pragma mark - produce

- (NSNumber *)scale:(NSNumber *) number;

// invert scale
- (NSNumber *)invert:(NSNumber *) number;

#pragma mark - ticks
// returns approximately count representative values from the scale's input domain.
// @see https://github.com/mbostock/d3/wiki/Quantitative-Scales#wiki-linear_ticks
- (NSArray *)ticks:(NSUInteger)count;
@end
```

## More Info

Very Nice article about D3.scale.

* [Jerome Cukier » d3: scales, and color.](http://www.jeromecukier.net/blog/2011/08/11/d3-scales-and-color/ "Jerome Cukier » d3: scales, and color.")

D3.js API Reference

* [D3.js Scales](https://github.com/mbostock/d3/wiki/Scales "Scales")

## Example

* [azu/LineChartOnRecycledScroll](https://github.com/azu/LineChartOnRecycledScroll "azu/LineChartOnRecycledScroll")
    * LineChart
* [azu/DrawLineLiz](https://github.com/azu/DrawLineLiz "azu/DrawLineLiz")
    * BarPlot

## Dependence

* [azu/ArsDashFunction](https://github.com/azu/ArsDashFunction "azu/ArsDashFunction")
    * Contain `ArsMin`, `ArsMax`, `ArsRange` etc...

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

3-clause BSD license

## Acknowledgment

```
D3.js
https://github.com/mbostock/d3
Copyright (c) 2010-2014, Michael Bostock
```
