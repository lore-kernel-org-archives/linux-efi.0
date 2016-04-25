From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH] efi: Fix out-of-bounds read in variable_matches()
Date: Mon, 25 Apr 2016 12:29:04 +0100
Message-ID: <1461583744-32034-1-git-send-email-matt@codeblueprint.co.uk>
References: <1461583602-31599-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1461583602-31599-1-git-send-email-matt@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Laszlo Ersek <lersek@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Chris Wilson <chris@chris-wilson.co.uk>, Jani Nikula <jani.nikula@linux.intel.com>, Jason Andryuk <jandryuk@gmail.com>, Matthew Garrett <mjg59@coreos.com>, Peter Jones <pjones@redhat.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Laszlo Ersek <lersek@redhat.com>

The variable_matches() function can currently read "var_name[len]", for
example when:

 - var_name[0] == 'a',
 - len == 1
 - match_name points to the NUL-terminated string "ab".

This function is supposed to accept "var_name" inputs that are not
NUL-terminated (hence the "len" parameter"). Document the function, and
access "var_name[*match]" only if "*match" is smaller than "len".

Reported-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
Cc: Peter Jones <pjones@redhat.com>
Cc: Matthew Garrett <mjg59@coreos.com>
Cc: Jason Andryuk <jandryuk@gmail.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: <stable@vger.kernel.org> # v3.10+
Link: http://thread.gmane.org/gmane.comp.freedesktop.xorg.drivers.intel/86906
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/vars.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 0ac594c0a234..34b741940494 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -202,29 +202,44 @@ static const struct variable_validate variable_validate[] = {
 	{ NULL_GUID, "", NULL },
 };
 
+/*
+ * Check if @var_name matches the pattern given in @match_name.
+ *
+ * @var_name: an array of @len non-NUL characters.
+ * @match_name: a NUL-terminated pattern string, optionally ending in "*". A
+ *              final "*" character matches any trailing characters @var_name,
+ *              including the case when there are none left in @var_name.
+ * @match: on output, the number of non-wildcard characters in @match_name
+ *         that @var_name matches, regardless of the return value.
+ * @return: whether @var_name fully matches @match_name.
+ */
 static bool
 variable_matches(const char *var_name, size_t len, const char *match_name,
 		 int *match)
 {
 	for (*match = 0; ; (*match)++) {
 		char c = match_name[*match];
-		char u = var_name[*match];
 
-		/* Wildcard in the matching name means we've matched */
-		if (c == '*')
+		switch (c) {
+		case '*':
+			/* Wildcard in @match_name means we've matched. */
 			return true;
 
-		/* Case sensitive match */
-		if (!c && *match == len)
-			return true;
+		case '\0':
+			/* @match_name has ended. Has @var_name too? */
+			return (*match == len);
 
-		if (c != u)
+		default:
+			/*
+			 * We've reached a non-wildcard char in @match_name.
+			 * Continue only if there's an identical character in
+			 * @var_name.
+			 */
+			if (*match < len && c == var_name[*match])
+				continue;
 			return false;
-
-		if (!c)
-			return true;
+		}
 	}
-	return true;
 }
 
 bool
-- 
2.7.3
