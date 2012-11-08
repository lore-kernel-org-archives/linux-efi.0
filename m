From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH RFC v2 0/4] Add firmware signature file check
Date: Thu,  8 Nov 2012 18:35:05 +0100
Message-ID: <1352396109-3989-1-git-send-email-tiwai@suse.de>
References: <s5hhap49den.wl%tiwai@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <s5hhap49den.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, joeyli <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi,

this is the revised patches I sent in this week for adding the
firmware signing support.  No big changes in the code but a bit of
clean ups and more descriptions in changelog and comments now.

At this point, it still needs to have a proper Kconfig help text, and
move the stuff of CONFIG_MODULE_SIG to be indepdent from CONFIG_MODULE
so that the code required for signature checks can be built for the
firmware loader even without module.

But, before doing that, I'd like to hear whether this approach is
really a way to go, or better to throw away and scratch.

Any suggests / comments appreciated.


thanks,

Takashi
