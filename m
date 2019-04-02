From: Matthew Garrett <mjg59@google.com>
Subject: Re: Add support for TCG2 log format on UEFI systems
Date: Mon, 1 Apr 2019 20:32:26 -0700
Message-ID: <CACdnJutCC7n++Nz5qy1YzmsSchEApDUvMH9-qpxYXckh-Dzf-Q@mail.gmail.com>
References: <20190227202658.197113-1-matthewgarrett@google.com> <20190401235245.GA29282@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190401235245.GA29282@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tomas.winkler@intel.com, linux-integrity <linux-integrity@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>, Roberto Sassu <roberto.sassu@huawei.com>, linux-efi <linux-efi@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 1, 2019 at 4:52 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Wed, Feb 27, 2019 at 12:26:54PM -0800, Matthew Garrett wrote:
> > Identical to V4, but based on tpmdd-next
>
> OK, so on my GLK NUC I get valid final log and invalid event log
> after adding some extra klogs.
>
> I.e.
>
> -       if (efi.tpm_log == EFI_INVALID_TABLE_ADDR)
> +       if (efi.tpm_log == EFI_INVALID_TABLE_ADDR) {

Just to make sure - are you booting via the EFI boot stub? We need to
obtain the boot log before ExitBootServices() is called, so if you're
booting directly into the 32-bit entry point (eg, by using the "linux"
command in grub) then you won't get a log.
