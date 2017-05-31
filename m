From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/5] security, efi: Set lockdown if in secure boot mode
Date: Wed, 31 May 2017 14:06:55 +0000
Message-ID: <CAKv+Gu83jXn4WYV1EQ0ixTmHnM7mTmb_XNHwcMxuH2sizOnHKw@mail.gmail.com>
References: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
 <CAKv+Gu_5gUWwx7Sxgm8d03L4t4nF8dDe+AXqOqto4B7AVSZ9CA@mail.gmail.com>
 <21606.1496222635@warthog.procyon.org.uk> <CAKv+Gu_vXASr=yDJ3MwT960eApqeWKEd-hqGoEyGsJKip7N+KQ@mail.gmail.com>
 <379.1496237632@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <379.1496237632@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-security-module <linux-security-module@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 31 May 2017 at 13:33, David Howells <dhowells@redhat.com> wrote:
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
>> No, I am fine with keeping this as a single series. I don't want
>> anything under drivers/efi to imply policy regarding lockdown. Kernel
>> lockdown should be a feature that lives somewhere else, and which
>> contains a CONFIG_ option that implies 'lockdown is enabled by default
>> when UEFI secure boot is detected.' The code that gets added to
>> drivers/efi should only concern itself with establishing whether
>> secure boot is in effect or not (and can hence be enabled
>> unconditionally)
>> ...
>> So what I would prefer is to separate this from the EFI code,
>
> In that case I don't know where to connect the UEFI secure boot with the
> lockdown code.
>
> I was under the impression that you wanted the switch-statement that I had in
> x86 setup.c moved to the efi code (as I've done in patch 1).  Was I wrong in
> that assessment and that you actually wanted it, say, in security?
>

No, that patch, and the patch that sets the EFI_SECURE_BOOT flag are
perfectly fine. I just think it should be the lockdown code that
contains the efi_enabled(EFI_SECURE_BOOT) check. Note that linux/efi.h
does the right thing in case CONFIG_EFI is not defined.

> I don't think that the non-EFI core code should know about UEFI secure boot
> mode.  Either the arch needs to implement the connection or the EFI code needs
> to implement it.  In the former is preferred, I should drop patch 1.
>
>> ... and perhaps print something like
>>
>> lockdown: Kernel lockdown policy in effect due to xxx
>
> I'm okay with printing that instead.
>
>> and print a subsequent line for every lockdown feature that is enabled, e.g.,
>>
>> lockdown: disabling MSRs
>> lockdown: disabling hibernate support
>
> That could add a lot of lines to the boot output:-/
>

Why is that a bad thing?
