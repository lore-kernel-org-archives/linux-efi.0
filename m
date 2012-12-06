From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Use PCI ROMs from EFI boot services
Date: Wed, 05 Dec 2012 17:04:09 -0800
Message-ID: <50BFEF09.9000408@zytor.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com> <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com> <20121203200241.GG5906@thinkpad-t410> <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com> <20121206001819.GA30527@srcf.ucam.org> <50BFE50C.8030008@zytor.com> <CAE9FiQX+M+VynyERC0W3y8rvr1tBxWnuBqJ6E-ywC_=HvJE66g@mail.gmail.com> <50BFE890.5070109@zytor.com> <d8d553fb-1571-4fdc-833c-92b80e15bc25@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <d8d553fb-1571-4fdc-833c-92b80e15bc25@email.android.com>
Sender: linux-pci-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-efi@vger.kernel.org

On 12/05/2012 04:57 PM, Matthew Garrett wrote:
> 
> 
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> I don't think there is anything security-sensitive about that
>> information, at least not to root.  I could be wrong, of course; I
>> wouldn't mind security people telling me about that.
> 
> I don't think there's anything at present, but we'll want to pass the hibernation encryption key from the bootloader to the kernel in the near future. setup_data seems like the easiest way to do that. 
> 

And that presumably would be something that cannot be exposed to root?
If so we may want to use one of the bits in the setup_data type field as
a security flag, perhaps...

	-hpa
