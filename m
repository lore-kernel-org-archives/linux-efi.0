From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH 3/3] x86/ima: retry detecting secure boot mode
Date: Thu, 7 Mar 2019 14:28:52 -0800
Message-ID: <CACdnJusqHZ1OLJD1baN=fXK9KE+bSqzB4OUbmLXH5-qZNrQXJg@mail.gmail.com>
References: <1542657371-7019-1-git-send-email-zohar@linux.ibm.com> <1542657371-7019-4-git-send-email-zohar@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542657371-7019-4-git-send-email-zohar@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, jforbes@redhat.com, Seth Forshee <seth.forshee@canonical.com>, kexec@lists.infradead.org, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 19, 2018 at 11:57 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> The secure boot mode may not be detected on boot for some reason (eg.
> buggy firmware).  This patch attempts one more time to detect the
> secure boot mode.

Do we have cases where this has actually been seen? I'm not sure what
the circumstances are that would result in this behaviour.
