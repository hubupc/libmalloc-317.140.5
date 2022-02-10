# libmalloc-317.140.5 编译

## 引言

- libmalloc 是苹果的堆内存管理库，它是一个开源项目（[苹果官方 libmalloc 源码](https://github.com/apple-oss-distributions/libmalloc)）。
- 为了更深入的了解其工作原理，我们希望能够直接使用源代码编译、调试。但从官网上下载的 libmalloc 源码是不能直接运行的，需要修改配置，补齐缺少的文件，屏蔽部分代码才能运行。
- 下面是我配置 libmalloc-317.140.5 版本的源码的记录。

## 环境

- macOS Big Sur 11.6
- Xcode 13.2.1

## libmalloc 源码

- [苹果官方 libmalloc 源码](https://github.com/apple-oss-distributions/libmalloc)

>*注：在 Releases 里，根据 tags 可以找到对应的版本*

## 依赖库

- xnu-7195.81.3
- dyld-832.7.3
- libplatform-254.80.2
- Libc-1353.41.1

## 设置依赖库目录

- 在 libmalloc 工程根目录下创建文件夹 PrivateHeaders；
- 打开 libmalloc 源码，点击左侧项目导航窗口中的工程文件 libmalloc，在右侧设置窗口中，TARGETS 栏目下选中 libsystem_malloc；
- 点击 Build Settings, 搜索 search path，在 Search Paths 栏目下，打开 Header Search Paths，新增 $(SRCROOT)/PrivateHeaders。

## 删除非必要 Target

- 保留 libsystem_malloc，其他都删除。

## 删除非必要 Schemes

- 保留 libsystem_malloc，其他都删除。

## 删除非必要文件及文件夹

- 文件：perfdata.framework、ktrace.framework
- 文件夹：resolver、tests、xcodeconfig、tools

## 编译错误处理

选中 Scheme: libsystem_malloc，编译

>*注：实测发现：cmd+B 编译报错，在没有任何修改的情况下，再次 cmd+B 编译，可能会优先报另一个错，所以实际操作过程中，报错顺序可能有些差异，按实际顺序修改即可。*

1. 问题：fatal error: '_simple.h' file not found  
   文件：libplatform-254.80.2/private/_simple.h  
   方案：将 _simple.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/
   
2. 问题：fatal error: 'platform/string.h' file not found  
   文件：libplatform-254.80.2/private/platform/string.h  
   方案：将 string.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/platform

3. 问题：fatal error: 'platform/compat.h' file not found  
   文件：libplatform-254.80.2/private/platform/compat.h  
   方案：将 compat.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/platform

4. 问题：fatal error: 'mach-o/dyld_priv.h' file not found  
   文件：dyld-832.7.3/include/mach-o/dyld_priv.h  
   方案：将 dyld_priv.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/mach-o/

5. 问题：fatal error: 'machine/cpu_capabilities.h' file not found  
   文件：xnu-7195.81.3/osfmk/machine/cpu_capabilities.h  
   方案：将 cpu_capabilities.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/machine/

6. 问题：fatal error: 'os/atomic_private.h' file not found  
   文件：xnu-7195.81.3/libkern/os/atomic_private.h  
   方案：将 atomic_private.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/os/

7. 问题：fatal error: 'atomic_private_impl.h' file not found  
    文件：xnu-7195.81.3/libkern/os/atomic_private_impl.h  
    方案：将 atomic_private_impl.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/

8. 问题：fatal error: 'atomic_private_arch.h' file not found  
    文件：xnu-7195.81.3/libkern/os/atomic_private_arch.h  
    方案：将 atomic_private_arch.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/

9. 问题：fatal error: 'os/crashlog_private.h' file not found  
    文件：libplatform-254.80.2/private/os/crashlog_private.h  
    方案：将 crashlog_private.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/os/

10. 问题：fatal error: 'os/base_private.h' file not found  
    文件：xnu-7195.81.3/libkern/os/base_private.h  
    方案：将 base_private.h 拷贝到 objc4-818.2/PrivateHeaders/os/

11. 问题：fatal error: 'os/lock_private.h' file not found  
    文件：libplatform-254.80.2/private/os/lock_private.h  
    方案：将 lock_private.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/os/

12. 问题：fatal error: 'os/once_private.h' file not found  
    文件：libplatform-254.80.2/private/os/once_private.h   
    方案：将 once_private.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/os/

13. 问题：fatal error: 'os/feature_private.h' file not found  
    方案：注释掉 libmalloc/src/internal 中的 line 65-67

14. 问题：fatal error: 'os/tsd.h' file not found  
    文件：xnu-7195.81.3/libsyscall/os/tsd.h  
    方案：将 tsd.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/os/

15. 问题：fatal error: 'pthread/private.h' file not found  
    文件：libpthread-454.80.2/private/pthread/private.h  
    方案：将 private.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/pthread/

16. 问题：fatal error: 'pthread/tsd_private.h' file not found  
    文件：libpthread-454.80.2/private/pthread/tsd_private.h  
    方案：  
    - 将 tsd_private.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/pthread/  
    - 将 tsd_private.h 中 Line 52 #include <System/machine/cpu_capabilities.h> 改为 #include <machine/cpu_capabilities.h> 

17. 问题：fatal error: 'pthread/spinlock_private.h' file not found  
    文件：libpthread-454.80.2/private/pthread/spinlock_private.h  
    方案：将 spinlock_private.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/pthread/

18. 问题：fatal error: 'thread_stack_pcs.h' file not found  
    文件：Libc-1353.41.1/gen/thread_stack_pcs.h   
    方案：将 thread_stack_pcs.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/


19. 问题：  
    - error: use of undeclared identifier '_COMM_PAGE_MEMORY_SIZE'  
    - error: use of undeclared identifier '_COMM_PAGE_NCPUS'  
    文件：  
    - xnu-7195.81.3/osfmk/arm/cpu_capabilities.h  
    - xnu-7195.81.3/osfmk/i386/cpu_capabilities.h    
    方案：  
    - 将 xnu-7195.81.3/osfmk/arm/cpu_capabilities.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/System/arm/  
    - 将 xnu-7195.81.3/osfmk/i386/cpu_capabilities.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/System/i386/  
    - 在 libmalloc-317.140.5/PrivateHeaders/machine/cpu_capabilities.h 中 Line 28 添加 #define PRIVATE

20. 问题：fatal error: 'sys/codesign.h' file not found  
    文件：xnu-7195.81.3/bsd/sys/codesign.h   
    方案：将 codesign.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/sys/

21. 问题：fatal error: 'System/kern/cs_blobs.h' file not found  
    文件：xnu-7195.81.3/osfmk/kern/cs_blobs.h   
    方案：将 cs_blobs.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/System/kern/

22. 问题：error: implicit declaration of function 'os_feature_enabled_simple' is invalid in C99   
    方案：将 libmalloc-317.140.5/src/platform 中 Line 117 #define   CONFIG_FEATUREFLAGS_SIMPLE 1 改为 #define CONFIG_FEATUREFLAGS_SIMPLE 0

23. 问题：fatal error: 'resolver.h' file not found  
    文件：libplatform-254.80.2/src/os/resolver/resolver.h  
    方案：将 resolver.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/

24. 问题：fatal error: 'resolver_internal.h' file not found  
    文件：libplatform-254.80.2/src/os/resolver/resolver_internal.h  
    方案：将 resolver_internal.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/

25. 问题：fatal error: 'os/internal.h' file not found  
    文件：libplatform-254.80.2/internal/os/internal.h  
    方案：将 internal.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/os/

26. 问题：fatal error: 'os/semaphore_private.h' file not found  
    文件：libplatform-254.80.2/private/os/semaphore_private.h  
    方案：将 semaphore_private.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/os/

27. 问题：fatal error: 'yield.h' file not found  
    文件：libplatform-254.80.2/internal/os/yield.h  
    方案：将 yield.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/

28. 问题：  
    - error: use of undeclared identifier 'NOTE_MEMORYSTATUS_PRESSURE_WARN'  
    - error: use of undeclared identifier 'NOTE_MEMORYSTATUS_MSL_STATUS'  
    - error: use of undeclared identifier 'NOTE_MEMORYSTATUS_PROC_LIMIT_WARN'  
    - error: use of undeclared identifier 'NOTE_MEMORYSTATUS_PROC_LIMIT_CRITICAL'  
    - error: use of undeclared identifier 'NOTE_MEMORYSTATUS_PRESSURE_CRITICAL'  
    文件：xnu-7195.81.3/bsd/sys/event.h   
    方案：  
    - 将 event.h 拷贝到 libmalloc-317.140.5/PrivateHeaders/sys  
    - 在 libmalloc-317.140.5/src/malloc.c 中 Line 25 添加 #include <sys/event.h>

29. 问题：
    - Undefined symbols for architecture x86_64:  
    - "_nanov2_configure", referenced from:    
      _nano_common_configure in nano_malloc_common.o  
    - "_nanov2_create_zone", referenced from:    
      \_\_\_malloc_init in malloc.o  
    - "_nanov2_forked_zone", referenced from:  
      \_\_malloc_fork_child in malloc.o  
    - "_nanov2_init", referenced from:  
      _nano_common_init in nano_malloc_common.o  
    - ld: symbol(s) not found for architecture x86_64    
    方案：  
    - 将 nano_malloc_common.c 中 Line 200 nanov2_configure() 改为 nano_configure()  
    - 将 nano_malloc_common.c 中 Line 145 nanov2_init(envp, apple, bootargs) 改为 nano_init(envp, apple, bootargs)  
    - 将 malloc.c 中 Line 2523 nanov2_forked_zone((nanozonev2_t *)initial_nano_zone) 改为 nano_forked_zone((nanozone_t *)initial_nano_zone)  
    - 将 malloc.c 中 Line 927 nano_zone = nanov2_create_zone(helper_zone, malloc_debug_flags) 改为 nano_zone = nano_create_zone(helper_zone, malloc_debug_flags)     - 将 malloc.c 中 Line 904-908 注释掉 

*至此，libmalloc-317.140.5 编译成功*

## 创建测试工程

- TARGETS 栏目底部点击加号，创建一个 macOS Command Line Tool 工程 libsystem_malloc_test
- TARGETS 栏目下选中 libsystem_malloc_test, 点击 Build Phases, 在 Dependencies 中添加依赖，选择 libsystem_malloc
- TARGETS 栏目下选中 libsystem_malloc_test, 点击 General, 在 Frameworks and Libraries 中添加引用，选择 libsystem_malloc，Do Not Embed

## 测试代码
文件：main.m

```
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
```

## 运行错误处理

1. 问题： (... .dylib) not valid for use in process using Library Validation: mapped file has no Team ID and is not a platform binary (signed with custom identity or adhoc?)  
   方案：设置 libsystem_malloc 与 libsystem_malloc_test 的 Development Team 一致：Build Settings ->Signing -> Development Team

2. 问题：malloc_zones[0]; Thread 1: EXC_BAD_ACCESS (code=EXC_I386_GPFLT)  
   方案：在 libmalloc-317.140.5/src/malloc.c 中添加代码： 

    ```
	// 添加初始化代码
	static os_once_t _malloc_initialize_pred;
	MALLOC_ALWAYS_INLINE
	static inline void
	_malloc_initialize_once(void)
	{
		os_once(&_malloc_initialize_pred, NULL, _malloc_initialize);
	}
   
    static inline malloc_zone_t *
    inline_malloc_default_zone(void)
    {
        // 添加初始化代码
        _malloc_initialize_once();

        // malloc_report(ASL_LEVEL_INFO, "In inline_malloc_default_zone with %d %d\n", malloc_num_zones, malloc_has_debug_zone);
        return malloc_zones[0];
    }
    ```
    >*注：这里参考了：cooci 老师的配置 [github malloc.c](https://github.com/LGCooci/KCCbjc4_debug/blob/master/libmalloc/libmalloc-317.40.8可编译/src/malloc.c)*
    
   分析：猜想是系统的 libmalloc 中的 __malloc_init 函数 （__malloc_init 中调用了 _malloc_initialize）会在某个时间点被其他库调用，完成初始化，而我们自己编译的 libmalloc 中的 __malloc_init 函数 并没有被调用。这样 malloc_zones 数组就是空的，所以会报错：EXC_BAD_ACCESS。解决方案是在 inline_malloc_default_zone 中手动添加初始化调用代码，仅在第一次进入 inline_malloc_default_zone 函数式调用。
   
   探索1：系统的 libmalloc 中的 __malloc_init 函数，是被哪个库调用的呢？我在 Libsystem （[苹果开源 Libsystem](https://github.com/apple-oss-distributions/Libsystem)）中找到了 __malloc_init 的调用点：
   
   文件：
   ```
   __attribute__((constructor))
    static void
    libSystem_initializer(int argc,
                          const char* argv[],
                          const char* envp[],
                          const char* apple[],
                          const struct ProgramVars* vars) 
    {
        // ...
        
        // TODO: Move __malloc_init before __libc_init after breaking malloc's upward link to Libc
        // Note that __malloc_init() will also initialize ASAN when it is present
        __malloc_init(apple);
        
        // ...
    }
   ```
   
   探索2：libSystem_initializer 又是何时调用的呢？之前在研究 Runtime 启动流程时在 _objc_init 函数中打断点，然后用 LLDB 命令打印 函数调用栈可以看到：
   
   ```
   (lldb) bt
    * thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 11.1
    * frame #0: 0x00000001002ed304 libobjc.A.dylib`_objc_init at objc-os.mm:925:9
      frame #1: 0x000000010046388f libdispatch.dylib`_os_object_init + 13
      frame #2: 0x0000000100474a03 libdispatch.dylib`libdispatch_init + 285
      frame #3: 0x00007fff2a5475ff libSystem.B.dylib`libSystem_initializer + 238
      frame #4: 0x0000000100031b47 dyld`ImageLoaderMachO::doModInitFunctions(ImageLoader::LinkContext const&) + 535
      frame #5: 0x0000000100031f52 dyld`ImageLoaderMachO::doInitialization(ImageLoader::LinkContext const&) + 40
      frame #6: 0x000000010002cae6 dyld`ImageLoader::recursiveInitialization(ImageLoader::LinkContext const&, unsigned int, char const*, ImageLoader::InitializerTimingList&, ImageLoader::UninitedUpwards&) + 492
      frame #7: 0x000000010002ca51 dyld`ImageLoader::recursiveInitialization(ImageLoader::LinkContext const&, unsigned int, char const*, ImageLoader::InitializerTimingList&, ImageLoader::UninitedUpwards&) + 343
      frame #8: 0x000000010002a89f dyld`ImageLoader::processInitializers(ImageLoader::LinkContext const&, unsigned int, ImageLoader::InitializerTimingList&, ImageLoader::UninitedUpwards&) + 191
      frame #9: 0x000000010002a940 dyld`ImageLoader::runInitializers(ImageLoader::LinkContext const&, ImageLoader::InitializerTimingList&) + 82
      frame #10: 0x000000010001686b dyld`dyld::initializeMainExecutable() + 129
      frame #11: 0x000000010001d041 dyld`dyld::_main(macho_header const*, unsigned long, int, char const**, char const**, char const**, unsigned long*) + 9098
      frame #12: 0x0000000100015224 dyld`dyldbootstrap::start(dyld3::MachOLoaded const*, int, char const**, dyld3::MachOLoaded const*, unsigned long*) + 450
      frame #13: 0x0000000100015025 dyld`_dyld_start + 37
   ```
   
   _dyld_start 的后续流程中调用了 libSystem_initializer 函数。
    这里是自己分析的流程，不确定是否正确，知道原因的朋友请留言。


*至此，libmalloc-317.140.5 运行成功*

## 总结

- libmalloc 的配置是个相当繁琐的过程，需要处理大量的编译错误和运行错误。其中屏蔽和删除了部分文件和代码，可能会有未知的问题。
- 我将配置好的 libmalloc 放在 github 上（[libmalloc-317.140.5](https://github.com/hubupc/libmalloc-317.140.5)），需要的朋友可以自己下载，记得需要配置下 Development Team，参考章节：运行错误处理。有兴趣的朋友也可以自己配置下。
   
## 参考资料

- [苹果开源 libmalloc](https://github.com/apple-oss-distributions/libmalloc)
- [苹果开源 objc4](https://github.com/apple-oss-distributions/objc4)
- [苹果开源 Libsystem](https://github.com/apple-oss-distributions/Libsystem)
- [iOS Runtime源码编译、调试 objc4-818.2](https://juejin.cn/post/6959465707046354975)
- [iOS 高级之美（六）—— malloc分析](https://juejin.cn/post/6844904033908424717)
