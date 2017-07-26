From: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC Part1 PATCH v3 13/17] x86/io: Unroll string I/O when SEV is
 active
Date: Wed, 26 Jul 2017 14:24:45 -0500
Message-ID: <ed6d4ce7-97a6-f664-d7d7-4ff48bc6f06a@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-14-brijesh.singh@amd.com>
 <063D6719AE5E284EB5DD2968C1650D6DD003FB85@AcuExch.aculab.com>
 <CAK8P3a3h7JpmkW7W=HwqAuWWmro=ngj6HSeiiML_=T82x-FtZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAK8P3a3h7JpmkW7W=HwqAuWWmro=ngj6HSeiiML_=T82x-FtZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>
Cc: brijesh.singh-5C7GfCeVMHo@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, =?UTF-8?Q?Radim_Krcm=c3=a1r?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Piotr Luc <piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


Hi Arnd and David,

On 07/26/2017 05:45 AM, Arnd Bergmann wrote:
> On Tue, Jul 25, 2017 at 11:51 AM, David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org> wrote:
>> From: Brijesh Singh
>>> Sent: 24 July 2017 20:08
>>> From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>>>
>>> Secure Encrypted Virtualization (SEV) does not support string I/O, so
>>> unroll the string I/O operation into a loop operating on one element at
>>> a time.
>>>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>>> Signed-off-by: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>
>>> ---
>>>   arch/x86/include/asm/io.h | 26 ++++++++++++++++++++++----
>>>   1 file changed, 22 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
>>> index e080a39..2f3c002 100644
>>> --- a/arch/x86/include/asm/io.h
>>> +++ b/arch/x86/include/asm/io.h
>>> @@ -327,14 +327,32 @@ static inline unsigned type in##bwl##_p(int port)                       \
>>>                                                                        \
>>>   static inline void outs##bwl(int port, const void *addr, unsigned long count) \
>>>   {
> 
> This will clash with a fix I did to add a "memory" clobber
> for the traditional implementation, see
> https://patchwork.kernel.org/patch/9854573/
> 
>> Is it even worth leaving these as inline functions?
>> Given the speed of IO cycles it is unlikely that the cost of calling a real
>> function will be significant.
>> The code bloat reduction will be significant.
> 
> I think the smallest code would be the original "rep insb" etc, which
> should be smaller than a function call, unlike the loop. Then again,
> there is a rather small number of affected device drivers, almost all
> of them for ancient hardware that you won't even build in a 64-bit
> x86 kernel, see the list below. The only user I found that is actually
> still relevant is drivers/tty/hvc/hvc_xen.c, which uses it for the early
> console.


There are some indirect user of string I/O functions. The following functions
defined in lib/iomap.c calls rep version of ins and outs.

- ioread8_rep, ioread16_rep, ioread32_rep
- iowrite8_rep, iowrite16_rep, iowrite32_rep

I found that several drivers use above functions.

Here is one approach to convert it into non-inline functions. In this approach,
I have added a new file arch/x86/kernel/io.c which provides non rep version of
string I/O routines. The file gets built and used only when AMD_MEM_ENCRYPT is
enabled. On positive side, if we don't build kernel with AMD_MEM_ENCRYPT support
then we use inline routines, when AMD_MEM_ENCRYPT is built then we make a function
call. Inside the function we unroll only when SEV is active.

Do you see any issue with this approach ? thanks

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index e080a39..104927d 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -323,8 +323,9 @@ static inline unsigned type in##bwl##_p(int port)                   \
         unsigned type value = in##bwl(port);                            \
         slow_down_io();                                                 \
         return value;                                                   \
-}                                                                      \
-                                                                       \
+}
+
+#define BUILDIO_REP(bwl, bw, type)                                     \
  static inline void outs##bwl(int port, const void *addr, unsigned long count) \
  {                                                                      \
         asm volatile("rep; outs" #bwl                                   \
@@ -335,12 +336,31 @@ static inline void ins##bwl(int port, void *addr, unsigned long count)    \
  {                                                                      \
         asm volatile("rep; ins" #bwl                                    \
                      : "+D"(addr), "+c"(count) : "d"(port));            \
-}
+}                                                                      \
  
  BUILDIO(b, b, char)
  BUILDIO(w, w, short)
  BUILDIO(l, , int)
  
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+extern void outsb_try_rep(int port, const void *addr, unsigned long count);
+extern void insb_try_rep(int port, void *addr, unsigned long count);
+extern void outsw_try_rep(int port, const void *addr, unsigned long count);
+extern void insw_try_rep(int port, void *addr, unsigned long count);
+extern void outsl_try_rep(int port, const void *addr, unsigned long count);
+extern void insl_try_rep(int port, void *addr, unsigned long count);
+#define outsb  outsb_try_rep
+#define insb   insb_try_rep
+#define outsw  outsw_try_rep
+#define insw   insw_try_rep
+#define outsl  outsl_try_rep
+#define insl   insl_try_rep
+#else
+BUILDIO_REP(b, b, char)
+BUILDIO_REP(w, w, short)
+BUILDIO_REP(l, , int)
+#endif
+
  extern void *xlate_dev_mem_ptr(phys_addr_t phys);
  extern void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr);

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a01892b..3b6e2a3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -42,6 +42,7 @@ CFLAGS_irq.o := -I$(src)/../include/asm/trace
  
  obj-y                  := process_$(BITS).o signal.o
  obj-$(CONFIG_COMPAT)   += signal_compat.o
+obj-$(CONFIG_AMD_MEM_ENCRYPT) += io.o
  obj-y                  += traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
  obj-y                  += time.o ioport.o dumpstack.o nmi.o
  obj-$(CONFIG_MODIFY_LDT_SYSCALL)       += ldt.o
diff --git a/arch/x86/kernel/io.c b/arch/x86/kernel/io.c
new file mode 100644
index 0000000..f58afa9
--- /dev/null
+++ b/arch/x86/kernel/io.c
@@ -0,0 +1,87 @@
+#include <linux/types.h>
+#include <linux/io.h>
+#include <asm/io.h>
+
+void outsb_try_rep(int port, const void *addr, unsigned long count)
+{
+       if (sev_active()) {
+               unsigned char *value = (unsigned char *)addr;
+               while (count) {
+                       outb(*value, port);
+                       value++;
+                       count--;
+               }
+       } else {
+               asm volatile("rep; outsb" : "+S"(addr), "+c"(count) : "d"(port));
+       }
+}
+
+void insb_try_rep(int port, void *addr, unsigned long count)
+{
+       if (sev_active()) {
+               unsigned char *value = (unsigned char *)addr;
+               while (count) {
+                       *value = inb(port);
+                       value++;
+                       count--;
+               }
+       } else {
+               asm volatile("rep; insb" : "+D"(addr), "+c"(count) : "d"(port));
+       }
+}
+
+void outsw_try_rep(int port, const void *addr, unsigned long count)
+{
+       if (sev_active()) {
+               unsigned short *value = (unsigned short *)addr;
+               while (count) {
+                       outw(*value, port);
+                       value++;
+                       count--;
+               }
+       } else {
+               asm volatile("rep; outsw" : "+S"(addr), "+c"(count) : "d"(port));
+       }
+}
+void insw_try_rep(int port, void *addr, unsigned long count)
+{
+       if (sev_active()) {
+               unsigned short *value = (unsigned short *)addr;
+               while (count) {
+                       *value = inw(port);
+                       value++;
+                       count--;
+               }
+       } else {
+               asm volatile("rep; insw" : "+D"(addr), "+c"(count) : "d"(port));
+       }
+}
+
+void outsl_try_rep(int port, const void *addr, unsigned long count)
+{
+       if (sev_active()) {
+               unsigned int *value = (unsigned int *)addr;
+               while (count) {
+                       outl(*value, port);
+                       value++;
+                       count--;
+               }
+       } else {
+               asm volatile("rep; outsl" : "+S"(addr), "+c"(count) : "d"(port));
+       }
+}
+
+void insl_try_rep(int port, void *addr, unsigned long count)
+{
+       if (sev_active()) {
+               unsigned int *value = (unsigned int *)addr;
+               while (count) {
+                       *value = inl(port);
+                       value++;
+                       count--;
+               }
+       } else {
+               asm volatile("rep; insl" : "+D"(addr), "+c"(count) : "d"(port));
+       }
+}
