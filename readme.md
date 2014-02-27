# ArsScale [![Build Status](https://travis-ci.org/azu/ArsScale.png)](https://travis-ci.org/azu/ArsScale)

A port into Objective-C of the [D3.js Scales](https://github.com/mbostock/d3/wiki/Scales "Scales").

## Installation

- [ ] Describe the installation process

## Usage

```objc
NSArray *dataArray = @[@1, @5, @10, @11, @22, @44, @55, @114];
ArsScaleLinear *scaleLinear = [[ArsScaleLinear alloc] init];
CGSize canvasSize = CGSizeMake(320, 480);
scaleLinear.domain = @[ArsMin(dataArray), ArsMax(dataArray)];
scaleLinear.range = @[@0, @(canvasSize.width)];
scaleLinear.clamp = YES;
scaleLinear.niceByStep([dataArray count]);
for (NSNumber *value in dataArray) {
    NSLog(@"Value:%@ , scale: %@", value, [scaleLinear scale:value]);
}
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

MIT