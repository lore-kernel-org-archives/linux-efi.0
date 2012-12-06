From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Use PCI ROMs from EFI boot services
Date: Thu, 6 Dec 2012 14:44:15 -0700
Message-ID: <CAErSpo4_Ob_VVY_t7X8Aczwg=DcQXS9xw-iPT4QX6JRSqwmyoA@mail.gmail.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
 <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
 <20121203200241.GG5906@thinkpad-t410> <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com>
 <50BFE88D.1000800@zytor.com> <CAE9FiQXwZAAMkWYT8EjsewpuZ-OWqoaFscyzGS_pSuO9C3bf9A@mail.gmail.com>
 <CAE9FiQX+aJi5XEyjfjc=K4eXLbQNqE-vd+coyt1dmuujsi_eoQ@mail.gmail.com>
 <CAErSpo7-hUbvvCYPSwtSYKMKWqu99A5H5R4004rSj5Bmv0593g@mail.gmail.com>
 <50C0E339.4030607@zytor.com> <20121206185439.GA17381@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20121206185439.GA17381@srcf.ucam.org>
Sender: linux-pci-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-efi@vger.kernel.org, dwmw2@infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Dec 6, 2012 at 11:54 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Dec 06, 2012 at 10:26:01AM -0800, H. Peter Anvin wrote:
>
>> NAK on this bit:
>>
>> +       if (boot_params.hdr.version < 0x0209)
>> +               return 0;
>>
>> This field is kernel->bootloader documentation.  If a nonmaching
>> value somehow leaks into the kernel, the kernel could either
>> panic("Bootloader written by moron") or it should clear some fields,
>> but littering the kernel with these kinds of tests is just plain
>> braindead.
>
> Dropping that should be fine. Bjorn, would you prefer a patch from me to
> do that?

I dropped that check and re-pushed my -next branch.

Yinghai, I don't understand your pa_data_setup_pci.patch, but if
somebody else acks it and we can come up with an intelligible
changelog, I'll fold that in, too.
