local M = {}

M.h = [[
#import <UIKit/UIKit.h>

@interface %s : NSObject

@end
]]

M.m = [[
#import "%s.h"

@interface %s ()

@end

@implementation %s

@end
]]

return M
