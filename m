From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH 3/3] x86/ima: retry detecting secure boot mode
Date: Fri, 08 Mar 2019 08:39:37 -0500
Message-ID: <1552052377.4134.23.camel@linux.ibm.com>
References: <1542657371-7019-1-git-send-email-zohar@linux.ibm.com>
         <1542657371-7019-4-git-send-email-zohar@linux.ibm.com>
         <CACdnJusqHZ1OLJD1baN=fXK9KE+bSqzB4OUbmLXH5-qZNrQXJg@mail.gmail.com>
         <CAFbkSA39RwB+E4SaG_ueu-_B=y7JytEYKw1+eXNQ_eCuMfnv=g@mail.gmail.com>
         <CACdnJuuHmK0qKjMxxonRYDUCatxqs930QGNQmREhRjimpNKzYw@mail.gmail.com>
         <1551998897.31706.461.camel@linux.ibm.com>
         <CACdnJusiLSCyqx7NX5bkpFr2N5YjBt_h3miOgkbey-Zndc3+Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJusiLSCyqx7NX5bkpFr2N5YjBt_h3miOgkbey-Zndc3+Kg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Justin Forbes <jforbes@redhat.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, kexec@lists.infradead.org, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 2019-03-07 at 14:50 -0800, Matthew Garrett wrote:
> On Thu, Mar 7, 2019 at 2:48 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> > I added this last attempt because I'm seeing this on my laptop, with
> > some older, buggy firmware.
> 
> Is the issue that it gives incorrect results on the first read, or is
> the issue that it gives incorrect results before ExitBootServices() is
> called? If the former then we should read twice in the boot stub, if
> the latter then we should figure out a way to do this immediately
> after ExitBootServices() instead.

Detecting the secure boot mode isn't the problem.  On boot, I am
seeing "EFI stub: UEFI Secure Boot is enabled", but setup_arch() emits
"Secure boot could not be determined".

In efi_main() the secure_boot mode is initially unset, so
efi_get_secureboot() is called.  efi_get_secureboot() returns the
secure_boot mode correctly as enabled.  The problem seems to be in
saving the secure_boot mode for later use.

Mimi
