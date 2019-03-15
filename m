From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: Add support for TCG2 log format on UEFI systems
Date: Fri, 15 Mar 2019 13:47:37 +0200
Message-ID: <20190315114737.GA4066@linux.intel.com>
References: <20190227202658.197113-1-matthewgarrett@google.com>
 <20190314093515.GA11165@linux.intel.com>
 <CACdnJuuWMg6c1GJHR3EMobaZ1CwquNudjcgxwXNWczE=3DbQTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJuuWMg6c1GJHR3EMobaZ1CwquNudjcgxwXNWczE=3DbQTg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: linux-integrity <linux-integrity@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>, Roberto Sassu <roberto.sassu@huawei.com>, linux-efi <linux-efi@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, =?iso-8859-1?Q?Thi=E9baud?= Weksteen <tweek@google.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 14, 2019 at 02:04:02PM -0700, Matthew Garrett wrote:
> On Thu, Mar 14, 2019 at 2:35 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Wed, Feb 27, 2019 at 12:26:54PM -0800, Matthew Garrett wrote:
> > > Identical to V4, but based on tpmdd-next
> >
> > This is not found /sys/kernel/security/tpm0/ascii_bios_measurements
> 
> That's expected - the existing kernel TCG2 log code doesn't expose
> ascii_bios_measurements, only binary_bios_measurements. This patchset
> doesn't change that.

Oops, I meant to point out that the binary_bios_measurents is not found
(i.e. ascii was a typo). The whole tpm0 directory is missing.

I'll try to pinpoint next week where things might go wrong on my system.

/Jarkko
