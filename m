From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Use PCI ROMs from EFI boot services
Date: Wed, 05 Dec 2012 16:21:32 -0800
Message-ID: <50BFE50C.8030008@zytor.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com> <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com> <20121203200241.GG5906@thinkpad-t410> <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com> <20121206001819.GA30527@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20121206001819.GA30527@srcf.ucam.org>
Sender: linux-pci-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-efi@vger.kernel.org

On 12/05/2012 04:18 PM, Matthew Garrett wrote:
> On Wed, Dec 05, 2012 at 04:15:56PM -0800, Yinghai Lu wrote:
> 
>> at the same time we should export setup_data into /sys, so kexec could
>> append this pointer to command of
>> second kernel, just like kexec append acpi_rsdp.
>> That should address DavidW's concern.
> 
> Why should the kernel export data to userspace just so that that data 
> can be passed back into the kernel?
> 

Because it also needs to modify it.  Right now kexec userspace
synthesizes struct boot_params from scratch, and does so incorrectly to
boot.  I think we have setup_data exported via debugfs but IIRC we never
got a strong enough use case for sysfs.

	-hpa
