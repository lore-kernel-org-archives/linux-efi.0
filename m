From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 0/2] Secure Boot: More controversial changes
Date: Mon, 28 Jan 2013 11:47:40 -0500
Message-ID: <1359391662-26120-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

These patches break functionality that people rely on without providing
any functional equivalent, so I'm not suggesting that they be merged
as-is. kexec allows trivial circumvention of the trust model (it's
trivially equivalent to permitting module loading, for instance) and
hibernation allows similar attacks (disable swap, write a pre-formed resume
image to swap, reboot). The hibernation patch also shows up a different
issue - some userspace drops all capabilities, resulting in things that
userspace expects to work no longer working. This seems like an
unsurprising result, but breaking userspace is bad and so it'd be nice to
figure out if there's another way to handle this.

