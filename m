From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v9 04/38] x86/CPU/AMD: Add the Secure Memory Encryption
 CPU feature
Date: Tue, 11 Jul 2017 10:14:34 -0500
Message-ID: <df089d57-3785-c669-6c3b-6f90f77c3658@amd.com>
References: <20170707133804.29711.1616.stgit@tlendack-t1.amdoffice.net>
 <20170707133850.29711.29549.stgit@tlendack-t1.amdoffice.net>
 <CAMzpN2j-gXvx2wAp3EvQB70Mr_oz0MSUzG=c-mhu-bnRiQGaFQ@mail.gmail.com>
 <f5657d4a-aa15-9602-bb36-1a3cfe7fbcc1@amd.com>
 <CAMzpN2hqYMVwhDRTGEhcUxqN2+6ToMmy6NBUutYJgPoOJEH4uQ@mail.gmail.com>
 <20170711055659.GA4554@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170711055659.GA4554-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo
List-Id: linux-efi@vger.kernel.org

On 7/11/2017 12:56 AM, Borislav Petkov wrote:
> On Tue, Jul 11, 2017 at 01:07:46AM -0400, Brian Gerst wrote:
>>> If I make the scattered feature support conditional on CONFIG_X86_64
>>> (based on comment below) then cpu_has() will always be false unless
>>> CONFIG_X86_64 is enabled. So this won't need to be wrapped by the
>>> #ifdef.
>>
>> If you change it to use cpu_feature_enabled(), gcc will see that it is
>> disabled and eliminate the dead code at compile time.
> 
> Just do this:
> 
>         if (cpu_has(c, X86_FEATURE_SME)) {
> 	       if (IS_ENABLED(CONFIG_X86_32)) {
>                         clear_cpu_cap(c, X86_FEATURE_SME);
> 	       } else {
> 		       u64 msr;
> 
> 		       /* Check if SME is enabled */
> 	              rdmsrl(MSR_K8_SYSCFG, msr);
> 	              if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
> 	                      clear_cpu_cap(c, X86_FEATURE_SME);
> 	       }
>         }
> 
> so that it is explicit that we disable it on 32-bit and we can save us
> the ifdeffery elsewhere.

I'll use this method for the change and avoid the #ifdefs.

Thanks,
Tom

> 
> Thanks.
> 
