From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Use PCI ROMs from EFI boot services
Date: Wed, 05 Dec 2012 20:00:13 -0500
Message-ID: <0e7c1b81-7572-4e4a-81c7-95ec2ce01881@email.android.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com> <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com> <20121203200241.GG5906@thinkpad-t410> <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com> <20121206001819.GA30527@srcf.ucam.org> <50BFE50C.8030008@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50BFE50C.8030008@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-efi@vger.kernel.org



"H. Peter Anvin" <hpa@zytor.com> wrote:

>Because it also needs to modify it.  Right now kexec userspace
>synthesizes struct boot_params from scratch, and does so incorrectly to
>boot.  I think we have setup_data exported via debugfs but IIRC we
>never
>got a strong enough use case for sysfs.

Kexec userspace needs updating every time we add functionality to setup_data? That really doesn't sound ideal. If we want to be able to pass secrets between kernels then this needs to be done in kernel space, not userland. 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
