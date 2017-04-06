From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/5] efi: Move the x86 secure boot switch to generic code
Date: Thu, 06 Apr 2017 13:54:23 +0100
Message-ID: <3598.1491483263@warthog.procyon.org.uk>
References: <149148299794.3427.549144000807596903.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <149148299794.3427.549144000807596903.stgit@warthog.procyon.org.uk>
Content-ID: <3597.1491483263.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: ard.biesheuvel@linaro.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Sorry, I forgot to include a cover note.

These five patches would replace 1-3 & 6 from my Kernel Lockdown series.  The
additional patch moves the secure boot switch from x86 to generic code.

David
