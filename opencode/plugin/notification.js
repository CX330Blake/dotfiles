export const NotificationPlugin = async ({
    project,
    client,
    $,
    directory,
    worktree,
}) => {
    const isMacOS = process.platform === "darwin";

    return {
        event: async ({ event }) => {
            // Send notification on session completion
            if (event.type === "session.idle" && isMacOS) {
                await $`osascript -e 'display notification "Session completed!" with title "opencode"'`;
            }
        },
    };
};
