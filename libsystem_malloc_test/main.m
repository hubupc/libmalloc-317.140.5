//
//  main.m
//  libsystem_malloc_test
//
//  Created by Yi Wang on 2022/2/9.
//

#import <Foundation/Foundation.h>
#import <malloc/malloc.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
		void *obj = calloc(1, 12);
		NSLog(@"%zu", malloc_size(obj));
		free(obj);
    }
	
    return 0;
}
