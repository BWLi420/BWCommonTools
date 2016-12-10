//
//  BWSingleton.h
//

#define interfaceSingleton(name) +(instancetype)share##name;

#if __has_feature(objc_arc)//判断是否为 ARC
// ARC
#define implementationSingleton(name) \
static name *_instance = nil; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[super allocWithZone:zone] init]; \
    }); \
    return _instance; \
} \
\
+ (instancetype)share##name{ \
    return [[self alloc] init]; \
} \
\
- (id)copyWithZone:(NSZone *)zone{ \
    return _instance; \
} \
\
- (id)mutableCopyWithZone:(NSZone *)zone{ \
    return _instance; \
}

#else

// MRC
#define implementationSingleton(name) \
static name *_instance = nil; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[super allocWithZone:zone] init]; \
}); \
return _instance; \
} \
\
+ (instancetype)share##name{ \
return [[self alloc] init]; \
} \
\
- (id)copyWithZone:(NSZone *)zone{ \
return _instance; \
} \
\
- (id)mutableCopyWithZone:(NSZone *)zone{ \
return _instance; \
} \
\
- (oneway void)release{ \
} \
\
- (instancetype)retain{ \
    return _instance; \
} \
\
- (NSUInteger)retainCount{ \
    return MAXFLOAT; \
} 

#endif
