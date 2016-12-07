From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: Does anything ever enter through startup_64 in head_64.S?
Date: Wed, 7 Dec 2016 15:24:34 +0000
Message-ID: <20161207152434.GB5462@codeblueprint.co.uk>
References: <21775.1481123477@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <21775.1481123477@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 07 Dec, at 03:11:17PM, David Howells wrote:
> Hi Matt,
> 
> Does anything ever enter the kernel through startup_64 in head_64.S?[*]  Do
> all 64-bit mode entries always enter through one of the EFI entry points?
 
Which head_64.S? There are two ;-)

Assuming you mean startup_64 in boot/compressed/head_64.S, then the
answer is "yes". 64-bit BIOS boot loaders will jump there.

I'm fairly sure it's possible to boot that way on EFI too, you just
lose some of the newer functionality that is dependent on the EFI boot
stub. But I don't remember the last time I tried it.

In general, we've always tried to maintain backwards compat, but you
don't get the new features without switching to the EFI entry points.

Whether or not any distros are still using the old 0x200 entry point
for EFI is a good question, though.
