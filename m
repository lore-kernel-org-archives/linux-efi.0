From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v6 25/34] swiotlb: Add warnings for use of bounce buffers
	with SME
Date: Thu, 8 Jun 2017 16:09:36 -0500
Message-ID: <56d5d7bf-45f9-6d66-d71a-166ecb60296c@amd.com>
References: <201706081348.u0hG73ce%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <201706081348.u0hG73ce%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEmy65B3kUBaIG@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 6/8/2017 12:53 AM, kbuild test robot wrote:
> Hi Tom,
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v4.12-rc4 next-20170607]
> [cannot apply to tip/x86/core]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Tom-Lendacky/x86-Secure-Memory-Encryption-AMD/20170608-104147
> config: sparc-defconfig (attached as .config)
> compiler: sparc-linux-gcc (GCC) 6.2.0
> reproduce:
>          wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          make.cross ARCH=sparc
> 
> All errors (new ones prefixed by >>):
> 
>     In file included from include/linux/dma-mapping.h:13:0,
>                      from include/linux/skbuff.h:34,
>                      from include/linux/filter.h:12,
>                      from kernel//bpf/core.c:24:
>>> include/linux/mem_encrypt.h:16:29: fatal error: asm/mem_encrypt.h: No such file or directory
>      #include <asm/mem_encrypt.h>
>                                  ^
>     compilation terminated.

Okay, I had the wrong understanding of the asm-generic directory. The
next series will fix this so it is not an issue for other arches.

Thanks,
Tom

> 
> vim +16 include/linux/mem_encrypt.h
> 
> 2d7c2ec4 Tom Lendacky 2017-06-07  10   * published by the Free Software Foundation.
> 2d7c2ec4 Tom Lendacky 2017-06-07  11   */
> 2d7c2ec4 Tom Lendacky 2017-06-07  12
> 2d7c2ec4 Tom Lendacky 2017-06-07  13  #ifndef __MEM_ENCRYPT_H__
> 2d7c2ec4 Tom Lendacky 2017-06-07  14  #define __MEM_ENCRYPT_H__
> 2d7c2ec4 Tom Lendacky 2017-06-07  15
> 2d7c2ec4 Tom Lendacky 2017-06-07 @16  #include <asm/mem_encrypt.h>
> 2d7c2ec4 Tom Lendacky 2017-06-07  17
> 2d7c2ec4 Tom Lendacky 2017-06-07  18  #endif	/* __MEM_ENCRYPT_H__ */
> 
> :::::: The code at line 16 was first introduced by commit
> :::::: 2d7c2ec4c60e83432b27bfb32042706f404d4158 x86/mm: Add Secure Memory Encryption (SME) support
> 
> :::::: TO: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
> :::::: CC: 0day robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
