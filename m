From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: Use PCI ROMs from EFI boot services
Date: Wed, 5 Dec 2012 16:22:00 -0800
Message-ID: <CAE9FiQXOLYL8D=-iBzg+SKnAwefP_uTHNh31UCHTSQg24VCQig@mail.gmail.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
	<CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
	<20121203200241.GG5906@thinkpad-t410>
	<CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com>
	<20121206001819.GA30527@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121206001819.GA30527@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org, "H. Peter Anvin" <hpa@zytor.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 5, 2012 at 4:18 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Dec 05, 2012 at 04:15:56PM -0800, Yinghai Lu wrote:
>
>> at the same time we should export setup_data into /sys, so kexec could
>> append this pointer to command of
>> second kernel, just like kexec append acpi_rsdp.
>> That should address DavidW's concern.
>
> Why should the kernel export data to userspace just so that that data
> can be passed back into the kernel?

then how the kexeced get those info?

first kernel already reserved those info as E820_RESERVED_KERN.
and those info are for bootloader's of first kernel.
