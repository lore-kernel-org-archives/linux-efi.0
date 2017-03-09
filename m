From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Thu, 9 Mar 2017 12:53:36 +0100
Message-ID: <CAKv+Gu-gRmt=Vq=QCcT5ETY9DwLzJe0f4gHR_9sFMKX7-vK++w@mail.gmail.com>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
 <20170309095408.GA17883@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20170309095408.GA17883@vader>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 9 March 2017 at 10:54, Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org> wrote:
> On Thu, Mar 09, 2017 at 02:38:06PM +0800, Dave Young wrote:
>> Add efi/kexec list.
>>
>> On 03/08/17 at 12:16pm, Omar Sandoval wrote:
>
> [snip]
>
>> I have no more clue yet from your provided log, but the runtime value is
>> odd to me. It is set in below code:
>>
>> arch/x86/platform/efi/efi.c: efi_systab_init()
>>       efi_systab.runtime = data ?
>>                            (void *)(unsigned long)data->runtime :
>>                            (void *)(unsigne long)systab64->runtime;
>>
>> Here data is the setup_data passed by kexec-tools from normal kernel to
>> kexec kernel, efi_setup_data structure is like below:
>> struct efi_setup_data {
>>         u64 fw_vendor;
>>         u64 runtime;
>>         u64 tables;
>>         u64 smbios;
>>         u64 reserved[8];
>> };
>>
>> kexec-tools get the runtime address from /sys/firmware/efi/runtime
>>
>> So can you do some debuggin on your side, eg. see the sysfs runtime
>> value is correct or not. And add some printk in efi init path etc.
>
> The attached patch fixes this for me.

Hi Omar,

Thanks for tracking this down.

I wonder if this is an unintended side effect of the way we repurpose
the EFI_MEMORY_RUNTIME attribute in efi_arch_mem_reserve(). AFAIUI,
splitting memory map entries should only be necessary for regions that
are not runtime memory regions to begin with, and so whether their
virtual mapping address makes sense or not should be irrelevant.

Perhaps this only illustrates my lack of understanding of the x86 way
of doing this, so perhaps Matt can shed some light on this?

Thanks,
Ard.
