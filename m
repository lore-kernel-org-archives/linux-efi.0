From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Fri, 16 Feb 2018 21:58:35 +0000
Message-ID: <CACdnJutPvMPUTWWjS3oRadQAqn+HpRpY+fhO0pXBj6OsQkAAag@mail.gmail.com>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
 <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q@mail.gmail.com>
 <1518814319.4419.10.camel@HansenPartnership.com> <3908561D78D1C84285E8C5FCA982C28F7B37942B@ORSMSX110.amr.corp.intel.com>
 <CALCETrXD4qCwgnDcwnybUXzVk7zyJtzHC2xzLfcZvzrXvAB8PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXD4qCwgnDcwnybUXzVk7zyJtzHC2xzLfcZvzrXvAB8PQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: luto@kernel.org
Cc: tony.luck@intel.com, James Bottomley <James.Bottomley@hansenpartnership.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, joe.konno@linux.intel.com, mingo@kernel.org, bp@alien8.de, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jk@ozlabs.org, ak@linux.intel.com, benjamin.drung@profitbricks.com, pjones@redhat.com
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 16, 2018 at 1:45 PM Andy Lutomirski <luto@kernel.org> wrote:
> I'm going to go out on a limb and suggest that the fact that
> unprivileged users can read efi variables at all is a mistake
> regardless of SMI issues.

Why? They should never contain sensitive material.

> Also, chmod() just shouldn't work on efi variables, and the mode
> passed to creat() should be ignored.  After all, there's no backing
> store for the mode.

If the default is 600 then it makes sense to allow a privileged service to
selectively make certain variables world readable at runtime.
