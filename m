From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 00/15] Secure boot policy support
Date: Mon, 28 Jan 2013 11:42:24 -0500
Message-ID: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Secure boot makes it possible to ensure that the on-disk representation of
the kernel hasn't been modified. This can be sidestepped if the in-memory
representation can be trivially altered. We currently have a large number
of interfaces that permit root to perform effectively arbitrary
modifications to the kernel, so this patchset introduces a new capability
("CAP_COMPROMISE_KERNEL") that controls whether or not these features are
available. The aim is for this to be useful in any other situations where
kernel integrity can be assured by some other mechanism rather than special
casing UEFI.

