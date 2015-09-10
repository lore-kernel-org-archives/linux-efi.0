From: Julien Grall <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub parameters
Date: Thu, 10 Sep 2015 12:48:05 +0100
Message-ID: <55F16DF5.1080705@citrix.com>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
 <20150910123251.7e0810d1@bender.Home>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150910123251.7e0810d1-I/y7IllHY3//9pzu0YdTqQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Turner <andrew-/GQUgJ3qWXsIvnNNuaVxrw@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Roger Pau Monne <roger.pau-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/09/15 12:32, Andrew Turner wrote:
> On Thu, 10 Sep 2015 16:41:56 +0800
> Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> 
>> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> These EFI stub parameters are used to internal communication between
>> EFI stub and Linux kernel and EFI stub creates these parameters. But
>> for Xen on ARM when booting with UEFI, Xen will create a minimal DT
>> providing these parameters for Dom0 and Dom0 is not only Linux
>> kernel, but also other OS (such as FreeBSD) which will be used in the
>> future. So here we plan to standardize the names by dropping the
>> prefix "linux," and make them common to other OS. Also this will not
>> break the compatibility since these parameters are used to internal
>> communication between EFI stub and kernel.
> 
> It is unlikely FreeBSD will use this property when booting ad Xen dom0.
> The kernel expects to be passed a data structure to find boot this
> information.
> 
> My preference would be to have the FreeBSD loader load the xen binary,
> the FreeBSD kernel, and set up these data structs before passing
> control to Xen, with the information it needs to boot the kernel. My
> understanding is this is how it is done on x86.

Well, AFAICT, there is no FreeBSD specific code in Xen for x86. We are
faking a multiboot module which contains all the informations.

I know that the bootloader is at least involved, I don't remember if
there is some code in FreeBSD to read this boot module. I've CCed Roger
to confirm.

> I can see a few issues with this where, for example, the device tree or
> ACPI tables need to be modified, but these should be solvable.

Xen has to modify the firmware table in order to remove everything that
it's used by itself (UART, virtual GIC...).

So we would need to modify the FreeBSD data structure to pass the new
DT/ACPI. Does the metadata are standardize? I.e is it stable from
accross FreeBSD version?

Anyway, I'd like to avoid any FreeBSD specific code in Xen, and even any
OS specific code in Xen. It's better if we keep a common interface for
everyone.

Regards,

-- 
Julien Grall
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
