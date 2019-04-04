From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH 1/2] efi: Fix cast to pointer from integer of different
 size in TPM log code
Date: Thu, 4 Apr 2019 10:23:59 -0700
Message-ID: <CACdnJusyj_eXi169ikNcfGG4HwVdNrxfd9LtRc-qYVaMbDDBTQ@mail.gmail.com>
References: <20190402215556.257406-1-matthewgarrett@google.com>
 <20190402215556.257406-2-matthewgarrett@google.com> <CAKv+Gu_yPKjK64qDEWgyacvKcoXwivoi4tq35T=uNE0syRhm8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_yPKjK64qDEWgyacvKcoXwivoi4tq35T=uNE0syRhm8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-integrity <linux-integrity@vger.kernel.org>, =?UTF-8?Q?Peter_H=C3=BCwe?= <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Roberto Sassu <roberto.sassu@huawei.com>, linux-efi <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thiebaud Weksteen <tweek@google.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 4, 2019 at 5:54 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Wed, 3 Apr 2019 at 04:56, Matthew Garrett <matthewgarrett@google.com> wrote:
> >
> > 8bfcff4a6a1d9d7226bb63a7da758b82d9ab4373
>
> Which tree is this commit in?

Sorry, these are in the tpmdd-next tree.
