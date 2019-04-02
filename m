From: Matthew Garrett <mjg59@google.com>
Subject: Re: Add support for TCG2 log format on UEFI systems
Date: Tue, 2 Apr 2019 10:15:39 -0700
Message-ID: <CACdnJuvFxKCwP3XftqacFiLTmTZzCGHkc9DzrJu2u6vwy5_o-w@mail.gmail.com>
References: <20190227202658.197113-1-matthewgarrett@google.com>
 <20190401235245.GA29282@linux.intel.com> <CACdnJutCC7n++Nz5qy1YzmsSchEApDUvMH9-qpxYXckh-Dzf-Q@mail.gmail.com>
 <20190402130704.GA3916@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402130704.GA3916@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tomas.winkler@intel.com, linux-integrity <linux-integrity@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>, Roberto Sassu <roberto.sassu@huawei.com>, linux-efi <linux-efi@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 2, 2019 at 6:07 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>
> I'll apply all patches soonish and include them to the next PR.

Thanks! Looks like I need some fixes to deal with non-x86
architectures, I'll get on that today.
