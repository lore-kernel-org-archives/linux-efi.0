From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Thu, 02 Nov 2017 18:10:41 -0400
Message-ID: <1509660641.3416.24.camel@linux.vnet.ibm.com>
References: <1509660086.3416.15.camel@linux.vnet.ibm.com>
         <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <14219.1509660259@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <14219.1509660259@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>, mcgrof@kernel.org
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi <linux-efi@vger.kernel.org>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 2017-11-02 at 22:04 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > > Only validly signed device firmware may be loaded.
> > 
> > fw_get_filesystem_firmware() calls kernel_read_file_from_path() to
> > read the firmware, which calls into the security hooks. Is there
> > another place that validates the firmware signatures.  I'm not seeing
> > which patch requires firmware to be signed?
> 
> Luis has a set of patches for this.  However, I'm not sure if that's going
> anywhere at the moment.  Possibly I should remove this from the manpage for
> the moment.

Or reflect that IMA-appraisal, if enabled, will enforce firmware being
validly signed.

Mimi

