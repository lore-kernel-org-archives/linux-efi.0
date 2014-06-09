From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] x86/boot: EFI_MIXED should not prohibit loading above 4G
Date: Mon, 9 Jun 2014 14:18:54 +0100
Message-ID: <CADknwL7Jeh82W3=rEqGqh=37zpqhmMuP1jy+DDq9vb2gQ+9hzg@mail.gmail.com>
References: <1402140380-15377-1-git-send-email-matt@console-pimps.org>
	<20140609125427.GA16256@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140609125427.GA16256@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, Dave Young <dyoung@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 9 June 2014 13:54, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Matt,
>
> So with new kexec syscall I have written 64bit bzImage loader. For now
> I would like to detect this situation and disable loading and once
> 32bit loader gets implemented it can take care of loading bzImage below
> 4G.

What situation do you want to detect? You want to detect when it's
impossible to load a kernel above 4G in the kexec path because you're
booting with 32-bit EFI firmware?

> So how do I find out if EFI is 32bit.

efi_enabled(EFI_64BIT) will tell you that, but you probably also want
to check that EFI runtime services are actually usable with
efi_enabled(EFI_RUNTIME_SERVICES) since if they're not, you'll never
call into the firmware so it doesn't matter where you load the kernel
(this may happen with "noefi" kernel parameter).
