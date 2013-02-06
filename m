From: Jeremy Kerr <jk@ozlabs.org>
Subject: [PATCH 0/3 v3] selftests: Add efivarfs tests
Date: Wed, 06 Feb 2013 22:48:08 +0800
Message-ID: <1360162088.142733.191120808822.0.gpush@pecola>
References: <1360162088.142733.191120808822.0.gpush@pecola>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360162088.142733.191120808822.0.gpush@pecola>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, Lingzhu Xiang <lxiang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

Hi all,

The following patches add a small set of tests to the
tools/testing/selftests directory. These cover some of the basic
functionality of efivarfs.

Comments welcome - changes 2 and 3 cover some behaviour that Matt and I
have discussed, but I'd appreciate any wider comment on the semantics
covered by these.

Cheers,


Jeremy

--
v2: Remove qemu check, add a couple of tests
v3: Change expected empty read() behaviour to return EOF

---
Jeremy Kerr (3):
      selftests: Add tests for efivarfs
      selftests/efivarfs: Add empty file creation test
      selftests/efivarfs: Add create-read test
