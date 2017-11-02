From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/27] security, efi: Add kernel lockdown
Date: Thu, 02 Nov 2017 18:01:26 -0400
Message-ID: <1509660086.3416.15.camel@linux.vnet.ibm.com>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>, linux-security-module@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

Hi David,

>From the man page:

> Only validly signed modules may be loaded.
> .P
> Only validly signed binaries may be kexec'd.
> .P
> Only validly signed device firmware may be loaded.

fw_get_filesystem_firmware() calls kernel_read_file_from_path() to
read the firmware, which calls into the security hooks. Is there
another place that validates the firmware signatures.  I'm not seeing
which patch requires firmware to be signed?

Mimi

