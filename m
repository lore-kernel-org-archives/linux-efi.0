From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: Do not allow MSR or Embedded Controller writes from userspace in secure boot case
Date: Fri, 09 Nov 2012 13:35:29 +0100
Message-ID: <91801952-f6b9-4cfd-b8b1-6ab57239d1ee@email.android.com>
References: <1352323699-52400-1-git-send-email-trenn@suse.de> <20121107215403.GA7277@srcf.ucam.org> <509AE5DA.1030508@zytor.com> <201211081538.34091.trenn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201211081538.34091.trenn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

We should only whitelist MSRs that are needed by some widely used things... no whitelist is the easiest.

Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org> wrote:

>On Wednesday, November 07, 2012 11:51:06 PM H. Peter Anvin wrote:
>> On 11/07/2012 10:54 PM, Matthew Garrett wrote:
>> > Is there a case where modifying MSRs or EC registers can cause
>> > arbitrary code execution?
>> 
>> For MSRs we could have a whitelist of permitted MSRs, but allowing
>> general MSR access... no.
>
>BTW: Who decides what is allowed and what is not?
>
>1) hpa?
>2) Intel
>3) The efi list?
>4) The spec?
>5) Windows when they threat distributions to revoke their
>   key if they do not do this and that?
>
>I guess it should be the spec. I haven't read the details, but
>when even Matthew is not sure, it sounds as if this is phrased
>rather imprecise. And as Windows is afaik the central key authority
>they can enforce their interpretation of the spec for Linux as well?
>
>An example:
>
>I have seen (shortened) a patch like this:
>
>Secure boot: Add a dummy kernel parameter that will switch on Secure
>Boot mode
>+__setup("secureboot_enable=", secureboot_enable_opt);
>
>This is to enforce secure boot restrictions even if
>HW does not support UEFI version 2.3.1 (or whatsoever).
>
>I like to have this boot parameter to also work the
>other way around:
>secureboot_enable=no
>and let all secure boot things fall off, only set a
>TAINT_INSECURE_BOOT_EVEN_BIOS_REQUESTED_SECURE_BOOT
>
>Can SUSE sign this kernel without fearing to get the key revoked
>from Windows?
>Can this exist in the mainline kernel?
>
>   Thomas

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
