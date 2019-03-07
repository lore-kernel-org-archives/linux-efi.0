From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH 3/3] x86/ima: retry detecting secure boot mode
Date: Thu, 07 Mar 2019 17:48:17 -0500
Message-ID: <1551998897.31706.461.camel@linux.ibm.com>
References: <1542657371-7019-1-git-send-email-zohar@linux.ibm.com>
         <1542657371-7019-4-git-send-email-zohar@linux.ibm.com>
         <CACdnJusqHZ1OLJD1baN=fXK9KE+bSqzB4OUbmLXH5-qZNrQXJg@mail.gmail.com>
         <CAFbkSA39RwB+E4SaG_ueu-_B=y7JytEYKw1+eXNQ_eCuMfnv=g@mail.gmail.com>
         <CACdnJuuHmK0qKjMxxonRYDUCatxqs930QGNQmREhRjimpNKzYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuuHmK0qKjMxxonRYDUCatxqs930QGNQmREhRjimpNKzYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>, Justin Forbes <jforbes@redhat.com>
Cc: linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, kexec@lists.infradead.org, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 2019-03-07 at 14:44 -0800, Matthew Garrett wrote:
> On Thu, Mar 7, 2019 at 2:38 PM Justin Forbes <jforbes@redhat.com> wrote:
> > On Thu, Mar 7, 2019 at 4:29 PM Matthew Garrett <mjg59@google.com> wrote:
> >>
> >> On Mon, Nov 19, 2018 at 11:57 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
> >> >
> >> > The secure boot mode may not be detected on boot for some reason (eg.
> >> > buggy firmware).  This patch attempts one more time to detect the
> >> > secure boot mode.
> >>
> >> Do we have cases where this has actually been seen? I'm not sure what
> >> the circumstances are that would result in this behaviour.
> >
> >
> > We have never seen it in practice, though we only ever do anything with it with x86, so it is possible that some other platforms maybe?
> 
> I'm not sure that it buys us anything to check this in both the boot
> stub and the running kernel. If a platform *is* giving us different
> results, anything else relying on the information from the boot stub
> is also going to be broken, so we should do this centrally rather than
> in the IMA code.

I added this last attempt because I'm seeing this on my laptop, with
some older, buggy firmware.

Mimi
