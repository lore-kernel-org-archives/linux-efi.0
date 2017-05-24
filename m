From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/5] efi: Move the x86 secure boot switch to generic code
Date: Wed, 24 May 2017 07:04:21 -0700
Message-ID: <CAKv+Gu8urtv9COMmBdSCFKTMsraepbb-9sAfDXKa5avH3=ufvg@mail.gmail.com>
References: <149148299794.3427.549144000807596903.stgit@warthog.procyon.org.uk>
 <CAKv+Gu9e-r+m6TEBPOg+o01m5JmF9CYLfH4dc60a_K41zJoCKg@mail.gmail.com> <23673.1495634085@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <23673.1495634085-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 May 2017 at 06:54, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> > +         UEFI Secure Boot provides a mechanism for ensuring that the firmware
>> > +         will only load signed bootloaders and kernels.  Secure boot mode may
>> > +         be determined from EFI variables provided by the BIOS if not
>>
>> Please replace 'the BIOS' with something more generic.
>
> "Firmware" or "System firmware" maybe?
>

Either is fine by me
