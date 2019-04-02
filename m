From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: Add support for TCG2 log format on UEFI systems
Date: Tue, 2 Apr 2019 16:07:04 +0300
Message-ID: <20190402130704.GA3916@linux.intel.com>
References: <20190227202658.197113-1-matthewgarrett@google.com>
 <20190401235245.GA29282@linux.intel.com>
 <CACdnJutCC7n++Nz5qy1YzmsSchEApDUvMH9-qpxYXckh-Dzf-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJutCC7n++Nz5qy1YzmsSchEApDUvMH9-qpxYXckh-Dzf-Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: tomas.winkler@intel.com, linux-integrity <linux-integrity@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>, Roberto Sassu <roberto.sassu@huawei.com>, linux-efi <linux-efi@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, =?iso-8859-1?Q?Thi=E9baud?= Weksteen <tweek@google.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 01, 2019 at 08:32:26PM -0700, Matthew Garrett wrote:
> On Mon, Apr 1, 2019 at 4:52 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Wed, Feb 27, 2019 at 12:26:54PM -0800, Matthew Garrett wrote:
> > > Identical to V4, but based on tpmdd-next
> >
> > OK, so on my GLK NUC I get valid final log and invalid event log
> > after adding some extra klogs.
> >
> > I.e.
> >
> > -       if (efi.tpm_log == EFI_INVALID_TABLE_ADDR)
> > +       if (efi.tpm_log == EFI_INVALID_TABLE_ADDR) {
> 
> Just to make sure - are you booting via the EFI boot stub? We need to
> obtain the boot log before ExitBootServices() is called, so if you're
> booting directly into the 32-bit entry point (eg, by using the "linux"
> command in grub) then you won't get a log.

... and I was wondering why it used to work when I tested the first
flush of patches. Ugh, sorry. The only excuse is too much multitasking
lately.

Anyway:

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I'll apply all patches soonish and include them to the next PR.

/Jarkko
