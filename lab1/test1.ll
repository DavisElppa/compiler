@str = constant [4 x i8] c"%f \00", align 1 ;预定义str，str1字???串,及其变量类型，方便后??的输入和输出
@str1 = constant [3 x i8] c"%d\00", align 1

define void @arr_set(float* %p, i32 %n)  {  ;%p寄存器为float数组p,%n表示数组长度变量n
  %tmp1 = alloca float*, align 8 ;分配空间，???齐方式??8字节 
  %tmp2 = alloca i32, align 4
  %tmp3 = alloca i32, align 4
  store float* %p, float** %tmp1, align 8 ;存入函数的参数值p,n
  store i32 %n, i32* %tmp2, align 4
  %tmp4 = call i64 @time(i64* null)  ;调用time函数
  %tmp5 = trunc i64 %tmp4 to i32
  call void @srand(i32 %tmp5)  ;将时间作为随机数种子，使每???得到的随机数都不相??
  store i32 0, i32* %tmp3, align 4  
  br label %judge1  

judge1:   ;for????条件的判??                                  
  %tmp6 = load i32, i32* %tmp3, align 4
  %tmp7 = load i32, i32* %tmp2, align 4
  %tmp8 = icmp slt i32 %tmp6, %tmp7 ;i与n大小的比较结??
  br i1 %tmp8, label %func1, label %ret ;如果i<n跳转到随机数复制操作，i>=n则跳出循??

func1:  ;通过随机函数给float数组赋??                                         
  %tmp9 = call i32 @rand()  ;调用随机函数
  %tmp10 = srem i32 %tmp9, 1000 ;随机函数的取值范围为0-999
  %tmp11 = sitofp i32 %tmp10 to double 
  %tmp12 = fadd double %tmp11, 1.000000e+00  ;0-999+1，即范围??1-1000
  %tmp13 = fdiv double %tmp12, 1.000000e+03  ;1-1000除以1000，浮点数的范围为0.001-1
  %tmp14 = fptrunc double %tmp13 to float    ;double类型??化为float
  %tmp15 = load float*, float** %tmp1, align 8   
  %tmp16 = load i32, i32* %tmp3, align 4   
  %tmp17 = sext i32 %tmp16 to i64
  %tmp18 = getelementptr inbounds float, float* %tmp15, i64 %tmp17  ;getelementptr指令来获得指向数组的元素的指针，这一步???获得p[i]的地址
  store float %tmp14, float* %tmp18, align 4  ;将随机数经过运算得到的值???制给浮点数数组
  br label %func2  ;跳转到func
 
func2:  ;用于i++                                             
  %tmp19 = load i32, i32* %tmp3, align 4 
  %tmp20 = add nsw i32 %tmp19, 1  ;i++
  store i32 %tmp20, i32* %tmp3, align 4  
  br label %judge1  ;重新跳转回判??????

ret:                                              
  ret void  ;返回值为??
}

declare  void @srand(i32) 

declare  i64 @time(i64*) 

declare  i32 @rand() 

; arr_print函数
define void @arr_print(float* %p, i32 %n)  {
  %i = alloca i32, align 4   ;创建变量i
  store i32 0, i32* %i, align 4   ;为i赋值，即i = 0
  br label %1

1:                                               ; 该部分判断while??句条?? 
  %check = icmp slt i32 %i, %n
  br i1 %check, label %2, label %3 ;判断i < n，若条件成立则进入循??，若不成立则????结束

2:                                               
  %pp = load float*, float** %p, align 8 ; 该部分执行printf函数，部分参考使用系统自带编译器生成的printf的LLVM代码
  %i32 = load i32, i32* %i, align 4
  %i64 = sext i32 %i32 to i64
  %pointer = getelementptr inbounds float, float* %pp, i64 %i64 ; getelementptr指令来获得指向数组的元素的指针，这一步???获得p[i]的地址
  %output = fpext float %pointer to double
  %none = call i32 (i8*, ...) @printf (i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str, i64 0, i64 0), double %output) ; 执???printf函数
  %ii = load i32, i32* %i, align 4 ; 该部分执行i++
  %plus = add nsw i32 %ii, 1
  store i32 %plus, i32* %i, align 4
  br label %1

3:                                               
  ret void
}

declare  i32 @printf(i8*, ...) 

; main函数
define i32 @main()  {
  %n = alloca i32, align 4 ; 定义n
  %none = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str1, i64 0, i64 0), i32* %n) ; 使用scanf输入n
  %p = alloca float*, align 8 ; 定义p
  store float* null, float** %p, align 8 ; *p = NULL 
  %n32 = load i32, i32* %n, align 4 ; 下面开始执行为p申???堆空间
  %n64 = sext i32 %n32 to i64
  %space = mul i64 4, %n64 ; 申???的地址空间大小??4*n
  %1 = call noalias i8* @malloc(i64 %space) 
  %pointer = bitcast i8* %1 to float*
  store float* %pointer, float** %p, align 8 ; 使p指向该地址空间
  call void @arr_set(float* %p, i32 %n) ; 调用arr_ser函数
  call void @arr_print(float* %p, i32 %n) ; 调用arr_print函数
  ret i32 0
}

declare  i32 @__isoc99_scanf(i8*, ...) 

declare  noalias i8* @malloc(i64) 
