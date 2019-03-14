From: Matthew Garrett <mjg59@google.com>
Subject: Re: Add support for TCG2 log format on UEFI systems
Date: Thu, 14 Mar 2019 14:04:02 -0700
Message-ID: <CACdnJuuWMg6c1GJHR3EMobaZ1CwquNudjcgxwXNWczE=3DbQTg@mail.gmail.com>
References: <20190227202658.197113-1-matthewgarrett@google.com> <20190314093515.GA11165@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190314093515.GA11165@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-integrity <linux-integrity@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>, Roberto Sassu <roberto.sassu@huawei.com>, linux-efi <linux-efi@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 14, 2019 at 2:35 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Wed, Feb 27, 2019 at 12:26:54PM -0800, Matthew Garrett wrote:
> > Identical to V4, but based on tpmdd-next
>
> This is not found /sys/kernel/security/tpm0/ascii_bios_measurements

That's expected - the existing kernel TCG2 log code doesn't expose
ascii_bios_measurements, only binary_bios_measurements. This patchset
doesn't change that.
