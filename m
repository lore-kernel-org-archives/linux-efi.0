From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Use PCI ROMs from EFI boot services
Date: Wed, 05 Dec 2012 16:36:32 -0800
Message-ID: <50BFE890.5070109@zytor.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com> <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com> <20121203200241.GG5906@thinkpad-t410> <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com> <20121206001819.GA30527@srcf.ucam.org> <50BFE50C.8030008@zytor.com> <CAE9FiQX+M+VynyERC0W3y8rvr1tBxWnuBqJ6E-ywC_=HvJE66g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAE9FiQX+M+VynyERC0W3y8rvr1tBxWnuBqJ6E-ywC_=HvJE66g@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-efi@vger.kernel.org

On 12/05/2012 04:30 PM, Yinghai Lu wrote:
> On Wed, Dec 5, 2012 at 4:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 12/05/2012 04:18 PM, Matthew Garrett wrote:
> 
>> Because it also needs to modify it.  Right now kexec userspace
>> synthesizes struct boot_params from scratch, and does so incorrectly to
>> boot.  I think we have setup_data exported via debugfs but IIRC we never
>> got a strong enough use case for sysfs.
> 
> maybe we could try  to export setup_data pointer only /sys, and that
> could be safe enough.
> 

I don't think there is anything security-sensitive about that
information, at least not to root.  I could be wrong, of course; I
wouldn't mind security people telling me about that.

	-hpa
