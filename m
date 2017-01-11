From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 0/8] efi: Pass secure boot mode to kernel [ver #6]
Date: Wed, 11 Jan 2017 15:01:50 +0000
Message-ID: <20170111150150.GC29649@codeblueprint.co.uk>
References: <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Thu, 08 Dec, at 12:30:08PM, David Howells wrote:
> 
> Here's a set of patches that can determine the secure boot state of the
> UEFI BIOS and pass that along to the main kernel image.  This involves
> generalising ARM's efi_get_secureboot() function and making it mixed-mode
> safe.

This version looks OK to me apart from the couple of comments I made.

Ard, did you take a look? In particular some boot testing on ARM/arm64
would be useful. x86 boots fine in both regular and mixed mode but
I've only tested without Secure Boot enabled.
